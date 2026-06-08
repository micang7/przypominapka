import { describe, it, expect, beforeEach, beforeAll } from 'vitest';
import request from 'supertest';
import { db } from '../../db/client.js';
import { sessions, users } from '../../db/schema.js';
import { app } from '../../app.js';
import { eq, sql } from 'drizzle-orm';
import { hash } from 'argon2';
import { generateTokens } from '../../utils/generateTokens.js';

describe('Users Module', () => {
  const api = request(app);
  let passwordHash: string;

  beforeAll(async () => {
    passwordHash = await hash('password123');
  });

  beforeEach(async () => {
    await db.execute(sql`TRUNCATE TABLE users RESTART IDENTITY CASCADE`);
  });

  describe('GET /users/me', () => {
    let userId: number;
    let accessToken: string;

    beforeEach(async () => {
      const [user] = await db
        .insert(users)
        .values({
          login: 'profileUser',
          passwordHash,
        })
        .returning();

      userId = user!.id;

      const tokens = await generateTokens(userId, 'device123', 'token123');
      accessToken = tokens.accessToken;
    });

    it('successfully fetches data of currently authenticated user', async () => {
      const res = await api
        .get('/api/v1/users/me')
        .set('Authorization', `Bearer ${accessToken}`)
        .send();

      expect(res.status).toBe(200);

      expect(res.body).toHaveProperty('id', userId);
      expect(res.body).toHaveProperty('login', 'profileUser');
      expect(res.body).toHaveProperty('createdAt');
      expect(res.body).toHaveProperty('updatedAt');
    });

    it('fails when authorization header is missing', async () => {
      const res = await api.get('/api/v1/users/me').send();

      expect(res.status).toBe(401);
      expect(res.body).toHaveProperty('message');
    });

    it('fails when authorization token is invalid', async () => {
      const res = await api
        .get('/api/v1/users/me')
        .set('Authorization', 'wrongAccessToken')
        .send();

      expect(res.status).toBe(401);
      expect(res.body).toHaveProperty('message');
    });

    it('fails when token is valid but user no longer exists in database', async () => {
      await db.delete(users).where(eq(users.id, userId));

      const res = await api
        .get('/api/v1/users/me')
        .set('Authorization', `Bearer ${accessToken}`)
        .send();

      expect(res.status).toBe(404);
      expect(res.body).toHaveProperty('message');
    });
  });

  describe('DELETE /users/me', () => {
    let userId: number;
    let accessToken: string;

    beforeEach(async () => {
      const [user] = await db
        .insert(users)
        .values({
          login: 'deleteMeUser',
          passwordHash,
        })
        .returning();

      userId = user!.id;

      const tokens = await generateTokens(userId, 'device123', 'token123');
      accessToken = tokens.accessToken;
    });

    it('successfully deletes the authenticated user account and their sessions', async () => {
      const res = await api
        .delete('/api/v1/users/me')
        .set('Authorization', `Bearer ${accessToken}`)
        .send();

      expect(res.status).toBe(204);

      const userInDb = await db
        .select()
        .from(users)
        .where(eq(users.id, userId));
      expect(userInDb.length).toBe(0);

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));
      expect(sessionsInDb.length).toBe(0);
    });

    it('fails when authorization header is missing', async () => {
      const res = await api.delete('/api/v1/users/me').send();

      expect(res.status).toBe(401);

      const userInDb = await db
        .select()
        .from(users)
        .where(eq(users.id, userId));
      expect(userInDb.length).toBe(1);
    });

    it('fails if user attempts to delete profile but does not exist in db', async () => {
      await db.delete(users).where(eq(users.id, userId));

      const res = await api
        .delete('/api/v1/users/me')
        .set('Authorization', `Bearer ${accessToken}`)
        .send();

      expect(res.status).toBe(404);
      expect(res.body.message).toBe('User not found');
    });
  });
});
