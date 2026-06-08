import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import { db } from '../../db/client.js';
import { sessions, users } from '../../db/schema.js';
import { app } from '../../app.js';
import { eq, sql } from 'drizzle-orm';
import { hash } from 'argon2';
import { generateTokens } from '../../utils/generateTokens.js';

describe('Sessions Module', () => {
  const api = request(app);

  beforeEach(async () => {
    await db.execute(
      sql`TRUNCATE TABLE users, sessions RESTART IDENTITY CASCADE`,
    );
  });

  describe('PATCH /sessions/fcm-token', () => {
    let userId: number;
    let accessToken: string;
    const deviceId = 'device123';

    beforeEach(async () => {
      const passwordHash = await hash('password123');
      const [user] = await db
        .insert(users)
        .values({
          login: 'sessionUser',
          passwordHash,
        })
        .returning();

      userId = user!.id;

      const tokens = await generateTokens(userId, deviceId);
      accessToken = tokens.accessToken;
    });

    it('updates FCM token successfully for an active device', async () => {
      const res = await api
        .patch('/api/v1/sessions/fcm-token')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          deviceId: deviceId,
          fcmToken: 'fcm-token',
        });

      expect(res.status).toBe(204);

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(sessionsInDb.length).toBe(1);
      expect(sessionsInDb[0]!.fcmToken).toBe('fcm-token');
      expect(sessionsInDb[0]!.deviceId).toBe(deviceId);
    });

    it('fails when there is no active session for the provided deviceId', async () => {
      const res = await api
        .patch('/api/v1/sessions/fcm-token')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          deviceId: 'different-device-id',
          fcmToken: 'fcm-token',
        });

      expect(res.status).toBe(401);
      expect(res.body).toHaveProperty('message');

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(sessionsInDb.length).toBe(1);
      expect(sessionsInDb[0]!.fcmToken).toBe(null);
    });

    it('fails when validation fields are missing or empty', async () => {
      const res = await api
        .patch('/api/v1/sessions/fcm-token')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          deviceId: '',
          fcmToken: '',
        });

      expect(res.status).toBe(400);
      expect(res.body).toHaveProperty('message');
      expect(res.body).toHaveProperty('errors');
    });

    it('updates only the session for the specific device when multiple sessions exist', async () => {
      const secondDevice = 'tablet456';
      await generateTokens(userId, secondDevice);

      await db.select().from(sessions).where(eq(sessions.userId, userId));

      const res = await api
        .patch('/api/v1/sessions/fcm-token')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          deviceId: deviceId,
          fcmToken: 'fcm-token',
        });

      expect(res.status).toBe(204);

      const finalSessions = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      const firstSession = finalSessions.find((s) => s.deviceId === deviceId);
      const secondSession = finalSessions.find(
        (s) => s.deviceId === secondDevice,
      );

      expect(firstSession!.fcmToken).toBe('fcm-token');
      expect(secondSession!.fcmToken).toBe(null);
    });
  });
});
