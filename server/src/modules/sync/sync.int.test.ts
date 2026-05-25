import { describe, it, expect, beforeEach, beforeAll } from 'vitest';
import request from 'supertest';
import { db } from '../../db/client.js';
import { users, tasks } from '../../db/schema.js';
import { app } from '../../app.js';
import { eq, sql } from 'drizzle-orm';
import { hash } from 'argon2';
import { generateTokens } from '../../utils/generateTokens.js';

describe('Sync Module', () => {
  const api = request(app);
  let userId: number;
  let accessToken: string;
  let passwordHash: string;

  beforeAll(async () => {
    passwordHash = await hash('password123');
  });

  beforeEach(async () => {
    await db.execute(
      sql`TRUNCATE TABLE users, sessions, tasks RESTART IDENTITY CASCADE`,
    );

    const [user] = await db
      .insert(users)
      .values({
        login: 'syncUser',
        passwordHash,
      })
      .returning();

    userId = user!.id;

    const tokens = await generateTokens(userId);
    accessToken = tokens.accessToken;
  });

  describe('POST /api/v1/sync', () => {
    it('successfully processes client changes and returns new sync timestamp', async () => {
      const taskId = 'e2b3b7c0-1111-4444-8888-1234567890ab';
      const lastSyncAt = new Date(Date.now() - 60000).toISOString();

      const res = await api
        .post('/api/v1/sync')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          last_sync_at: lastSyncAt,
          changes: {
            created: [
              {
                id: taskId,
                title: 'New Client Task',
                description: 'Description',
                type: 'one_time',
                timeTriggerAt: null,
                geoTriggerLatitude: null,
                geoTriggerLongitude: null,
                geoTriggerRadius: null,
              },
            ],
            updated: [],
            deleted: [],
          },
        });

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('sync_at');
      expect(new Date(res.body.sync_at as string).getTime()).toBeGreaterThan(
        new Date(lastSyncAt).getTime(),
      );

      // Sprawdzenie, czy struktura odpowiedzi dla nowych zmian jest czysta (klient nie dostaje swoich własnych zmian)
      expect(res.body.changes.created).toHaveLength(0);
      expect(res.body.changes.updated).toHaveLength(0);
      expect(res.body.changes.deleted).toHaveLength(0);

      // Sprawdzenie zapisu w bazie danych
      const taskInDb = await db.query.tasks.findFirst({
        where: eq(tasks.id, taskId),
      });
      expect(taskInDb).toBeDefined();
      expect(taskInDb!.title).toBe('New Client Task');
    });

    it('successfully soft deletes server task when client requests deletion', async () => {
      const taskId = 'e2b3b7c0-2222-4444-8888-1234567890ab';

      // Wstrzyknięcie istniejącego zadania do bazy danych
      await db.insert(tasks).values({
        id: taskId,
        userId: userId,
        title: 'Task to delete',
        type: 'one_time',
      });

      const res = await api
        .post('/api/v1/sync')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          last_sync_at: new Date().toISOString(),
          changes: {
            created: [],
            updated: [],
            deleted: [{ id: taskId }],
          },
        });

      expect(res.status).toBe(200);

      // Sprawdzenie polityki Soft Delete w bazie danych
      const taskInDb = await db.query.tasks.findFirst({
        where: eq(tasks.id, taskId),
      });
      expect(taskInDb).toBeDefined();
      expect(taskInDb!.deletedAt).not.toBeNull();
    });

    it('returns server-side changes (created/updated/deleted) to the client', async () => {
      const pastSyncTime = new Date(Date.now() - 5000);

      const createdTaskId = 'e2b3b7c0-3333-4444-8888-1234567890ab';
      const updatedTaskId = 'e2b3b7c0-4444-4444-8888-1234567890ab';
      const deletedTaskId = 'e2b3b7c0-5555-4444-8888-1234567890ab';

      // 1. Zadanie stworzone na serwerze po ostatnim syncu klienta
      await db.insert(tasks).values({
        id: createdTaskId,
        userId,
        title: 'Server Created Task',
        type: 'one_time',
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      // 2. Zadanie zaktualizowane na serwerze po ostatnim syncu klienta
      await db.insert(tasks).values({
        id: updatedTaskId,
        userId,
        title: 'Server Updated Task',
        type: 'recurrent',
        createdAt: new Date(Date.now() - 10000),
        updatedAt: new Date(),
      });

      // 3. Zadanie usunięte (soft delete) na serwerze po ostatnim syncu klienta
      await db.insert(tasks).values({
        id: deletedTaskId,
        userId,
        title: 'Server Deleted Task',
        type: 'one_time',
        createdAt: new Date(Date.now() - 10000),
        updatedAt: new Date(),
        deletedAt: new Date(),
      });

      const res = await api
        .post('/api/v1/sync')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          last_sync_at: pastSyncTime.toISOString(),
          changes: { created: [], updated: [], deleted: [] },
        });

      expect(res.status).toBe(200);

      // Weryfikacja odebrania zmian serwerowych
      const { created, updated, deleted } = res.body.changes;

      expect(created.length).toBe(1);
      expect(created[0].id).toBe(createdTaskId);
      expect(created[0]).toHaveProperty('createdAt');

      expect(updated.length).toBe(1);
      expect(updated[0].id).toBe(updatedTaskId);

      expect(deleted.length).toBe(1);
      expect(deleted[0].id).toBe(deletedTaskId);
    });

    it('fails when authorization token is missing', async () => {
      const res = await api.post('/api/v1/sync').send({
        last_sync_at: new Date().toISOString(),
        changes: { created: [], updated: [], deleted: [] },
      });

      expect(res.status).toBe(401);
      expect(res.body).toHaveProperty('message');
    });

    it('fails when request body payload validation fails', async () => {
      const res = await api
        .post('/api/v1/sync')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          last_sync_at: 'not-a-date',
        });

      expect(res.status).toBe(400);
      expect(res.body).toHaveProperty('message');
      expect(res.body).toHaveProperty('errors');
    });
  });
});
