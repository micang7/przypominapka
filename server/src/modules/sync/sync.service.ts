import { db } from '../../db/client.js';
import { sessions, tasks } from '../../db/schema.js';
import {
  and,
  eq,
  gt,
  inArray,
  isNotNull,
  not,
  notInArray,
  sql,
} from 'drizzle-orm';
import type { SyncDtoType } from '../../api/dtos/sync/sync.dto.js';
import type { SyncResDtoType } from '../../api/dtos/sync/sync.res.dto.js';
import { appLogger } from '../../config/logger.js';
import admin from 'firebase-admin';

admin.initializeApp();

class SyncService {
  async sync(userId: number, data: SyncDtoType): Promise<SyncResDtoType> {
    const { last_sync_at, changes } = data;
    const syncAt = new Date();

    appLogger.debug(
      { userId, lastSyncAt: last_sync_at },
      'Two-way synchronization initiated',
    );

    // Wyciągamy ID elementów zmienionych przez klienta, aby nie odsyłać ich w odpowiedzi
    const clientCreatedIds = changes.created.map((t) => t.id);
    const clientUpdatedIds = changes.updated.map((t) => t.id);
    const clientDeletedIds = changes.deleted.map((t) => t.id);

    const processedIds = [
      ...clientCreatedIds,
      ...clientUpdatedIds,
      ...clientDeletedIds,
    ];

    // 1. Przetwarzanie zmian przesłanych od klienta w ramach jednej transakcji
    await db.transaction(async (tx) => {
      // A. CREATED (Zadania utworzone na kliencie)
      if (changes.created.length > 0) {
        appLogger.debug(
          { userId, count: changes.created.length },
          'Processing client created tasks',
        );
        const tasksToInsert = changes.created.map((task) => ({
          id: task.id,
          userId: userId,
          title: task.title,
          description: task.description,
          type: task.type,
          completed: false,
          timeTriggerAt: task.timeTriggerAt
            ? new Date(task.timeTriggerAt)
            : null,
          geoTriggerLatitude: task.geoTriggerLatitude,
          geoTriggerLongitude: task.geoTriggerLongitude,
          geoTriggerRadius: task.geoTriggerRadius,
          createdAt: syncAt,
          updatedAt: syncAt,
        }));

        await tx.insert(tasks).values(tasksToInsert).onConflictDoNothing();
      }

      // B. UPDATED (Zadania zmodyfikowane na kliencie)
      if (changes.updated.length > 0) {
        appLogger.debug(
          { userId, count: changes.updated.length },
          'Processing client updated tasks',
        );
        const tasksToUpdate = changes.updated.map((task) => ({
          id: task.id,
          userId: userId,
          title: task.title || '',
          description: task.description,
          type: task.type,
          completed: false,
          timeTriggerAt: task.timeTriggerAt
            ? new Date(task.timeTriggerAt)
            : null,
          geoTriggerLatitude: task.geoTriggerLatitude,
          geoTriggerLongitude: task.geoTriggerLongitude,
          geoTriggerRadius: task.geoTriggerRadius,
          createdAt: syncAt,
          updatedAt: syncAt,
        }));

        await tx
          .insert(tasks)
          .values(tasksToUpdate)
          .onConflictDoUpdate({
            target: tasks.id,
            set: {
              title: sql`excluded.title`,
              description: sql`excluded.description`,
              type: sql`excluded.type`,
              completed: sql`excluded.completed`,
              timeTriggerAt: sql`excluded.time_trigger_at`,
              geoTriggerLatitude: sql`excluded.geo_trigger_latitude`,
              geoTriggerLongitude: sql`excluded.geo_trigger_longitude`,
              geoTriggerRadius: sql`excluded.geo_trigger_radius`,
              updatedAt: sql`excluded.updated_at`,
            },
          });
      }

      // C. DELETED (Zadania usunięte na kliencie)
      if (changes.deleted.length > 0) {
        appLogger.debug(
          { userId, count: changes.deleted.length },
          'Processing client deleted tasks',
        );

        await tx
          .update(tasks)
          .set({ deletedAt: syncAt })
          .where(
            and(inArray(tasks.id, clientDeletedIds), eq(tasks.userId, userId)),
          );
      }
    });

    // 2. Pobieranie zmian z serwera, o których klient jeszcze nie wie
    const lastSyncDate = new Date(last_sync_at);

    // A. Serwerowe CREATED & UPDATED
    // Pobieramy rekordy zmodyfikowane/utworzone po `last_sync_at`, wykluczając ID przetworzone wyżej
    const serverChanges = await db
      .select()
      .from(tasks)
      .where(
        and(
          eq(tasks.userId, userId),
          gt(tasks.updatedAt, lastSyncDate),
          processedIds.length > 0
            ? notInArray(tasks.id, processedIds)
            : undefined,
        ),
      );

    const serverCreated = [];
    const serverUpdated = [];
    const serverDeleted = [];

    for (const task of serverChanges) {
      if (task.deletedAt && task.deletedAt > lastSyncDate) {
        serverDeleted.push({ id: task.id });
        continue;
      }

      const formattedTask = {
        id: task.id,
        title: task.title,
        description: task.description,
        type: task.type,
        completed: task.completed,
        timeTriggerAt: task.timeTriggerAt
          ? task.timeTriggerAt.toISOString()
          : null,
        geoTriggerLatitude: task.geoTriggerLatitude
          ? Number(task.geoTriggerLatitude)
          : null,
        geoTriggerLongitude: task.geoTriggerLongitude
          ? Number(task.geoTriggerLongitude)
          : null,
        geoTriggerRadius: task.geoTriggerRadius,
        updatedAt: task.updatedAt.toISOString(),
      };

      if (task.createdAt > lastSyncDate) {
        serverCreated.push({
          ...formattedTask,
          createdAt: task.createdAt.toISOString(),
        });
      } else {
        serverUpdated.push(formattedTask);
      }
    }

    try {
      const activeOtherSessions = await db
        .select({ fcmToken: sessions.fcmToken })
        .from(sessions)
        .where(
          and(
            eq(sessions.userId, userId),
            not(eq(sessions.deviceId, data.deviceId)),
            isNotNull(sessions.fcmToken),
          ),
        );

      appLogger.debug(
        { userId, targetDevices: activeOtherSessions.length },
        'Other user devices found',
      );

      if (activeOtherSessions.length > 0) {
        const message = {
          data: {
            type: 'SYNC_REQUEST',
            timestamp: new Date().toISOString(),
          },
          tokens: activeOtherSessions.map((s) => s.fcmToken!),
        };

        const response = await admin.messaging().sendEachForMulticast(message);

        appLogger.info(
          { userId, targetDevices: response.successCount },
          'FCM synchronization request sent to other devices',
        );
      }
    } catch (err) {
      appLogger.error(
        { userId, err },
        'Failed to send FCM synchronization request',
      );
    }

    appLogger.info(
      {
        userId,
        serverCreated: serverCreated.length,
        serverUpdated: serverUpdated.length,
        serverDeleted: serverDeleted.length,
      },
      'Two-way synchronization completed successfully',
    );

    return {
      sync_at: syncAt.toISOString(),
      changes: {
        created: serverCreated,
        updated: serverUpdated,
        deleted: serverDeleted,
      },
    };
  }
}

export const syncService = new SyncService();
