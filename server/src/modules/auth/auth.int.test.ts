import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import { db } from '../../db/client.js';
import { sessions, users } from '../../db/schema.js';
import { app } from '../../app.js';
import { eq, sql } from 'drizzle-orm';
import { hash, verify } from 'argon2';
import { generateTokens } from '../../utils/generateTokens.js';

describe('Auth Module', () => {
  const api = request(app);

  beforeEach(async () => {
    await db.execute(
      sql`TRUNCATE TABLE users, sessions RESTART IDENTITY CASCADE`,
    );
  });

  describe('POST /auth/register', () => {
    it('registers user successfully', async () => {
      const res = await api.post('/api/v1/auth/register').send({
        login: 'testuser',
        password: 'password123',
        confirmPassword: 'password123',
      });

      expect(res.status).toBe(201);

      expect(res.body).toHaveProperty('user');
      expect(res.body.user.login).toBe('testuser');

      expect(res.body).toHaveProperty('accessToken');
      expect(res.body).toHaveProperty('refreshToken');
      expect(res.body.accessTokenExpiresAt).toBeDefined();
      expect(res.body.refreshTokenExpiresAt).toBeDefined();
    });

    it('fails when passwords do not match', async () => {
      const res = await api.post('/api/v1/auth/register').send({
        login: 'testuser',
        password: 'password123',
        confirmPassword: 'different',
      });

      expect(res.status).toBe(400);

      expect(res.body).toHaveProperty('message');
      expect(res.body).toHaveProperty('errors');
    });

    it('fails when login is already in use', async () => {
      await api.post('/api/v1/auth/register').send({
        login: 'duplicate',
        password: 'password123',
        confirmPassword: 'password123',
      });

      const res = await api.post('/api/v1/auth/register').send({
        login: 'duplicate',
        password: 'password123',
        confirmPassword: 'password123',
      });

      expect(res.status).toBe(409);

      expect(res.body.message).toBe('Login already in use');
      expect(res.body.paths).toContain('login');
    });

    it('stores user in database', async () => {
      await api.post('/api/v1/auth/register').send({
        login: 'dbcheck',
        password: 'password123',
        confirmPassword: 'password123',
      });

      const usersInDb = await db.select().from(users);

      expect(usersInDb.length).toBe(1);
      expect(usersInDb[0]!.login).toBe('dbcheck');
      expect(usersInDb[0]!.passwordHash).toBeDefined();
      expect(usersInDb[0]!.passwordHash).not.toBe('password123');
    });
  });

  describe('POST /auth/login', () => {
    let passwordHash: string;

    beforeAll(async () => {
      passwordHash = await hash('password123');
    });

    beforeEach(async () => {
      await db.insert(users).values({
        login: 'testuser',
        passwordHash,
      });
    });

    it('logs in successfully', async () => {
      const res = await api.post('/api/v1/auth/login').send({
        login: 'testuser',
        password: 'password123',
      });

      expect(res.status).toBe(200);

      expect(res.body).toHaveProperty('user');
      expect(res.body.user.login).toBe('testuser');

      expect(res.body).toHaveProperty('accessToken');
      expect(res.body).toHaveProperty('refreshToken');
      expect(res.body.accessTokenExpiresAt).toBeDefined();
      expect(res.body.refreshTokenExpiresAt).toBeDefined();
    });

    it('fails when login does not exist', async () => {
      const res = await api.post('/api/v1/auth/login').send({
        login: 'unknown',
        password: 'password123',
      });

      expect(res.status).toBe(401);

      expect(res.body.message).toBe('Invalid login or password');
    });

    it('fails when password is incorrect', async () => {
      const res = await api.post('/api/v1/auth/login').send({
        login: 'testuser',
        password: 'wrongpassword',
      });

      expect(res.status).toBe(401);

      expect(res.body.message).toBe('Invalid login or password');
    });

    it('fails when required fields are missing', async () => {
      const res = await api.post('/api/v1/auth/login').send({
        login: '',
        password: '',
      });

      expect(res.status).toBe(400);

      expect(res.body).toHaveProperty('message');
      expect(res.body).toHaveProperty('errors');
    });
  });

  describe('POST /auth/logout', () => {
    let userId: number;
    let accessToken: string;
    let refreshToken: string;

    let passwordHash: string;

    beforeAll(async () => {
      passwordHash = await hash('password123');
    });

    beforeEach(async () => {
      const [user] = await db
        .insert(users)
        .values({
          login: 'logoutUser',
          passwordHash,
        })
        .returning();

      userId = user!.id;

      const tokens = await generateTokens(userId);
      accessToken = tokens.accessToken;
      refreshToken = tokens.refreshToken;
    });

    it('logs out successfully and removes session', async () => {
      const res = await api
        .post('/api/v1/auth/logout')
        .set('Authorization', `Bearer ${accessToken}`)
        .set('x-refresh-token', refreshToken)
        .send();

      expect(res.status).toBe(204);

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(sessionsInDb.length).toBe(0);
    });

    it('does nothing when refresh token does not match any session', async () => {
      const res = await api
        .post('/api/v1/auth/logout')
        .set('Authorization', `Bearer ${accessToken}`)
        .set('x-refresh-token', 'wrongRefreshToken')
        .send();

      expect(res.status).toBe(204);

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(sessionsInDb.length).toBe(1);
    });

    it('does nothing when user has no sessions', async () => {
      await db.delete(sessions).where(eq(sessions.userId, userId));

      const res = await api
        .post('/api/v1/auth/logout')
        .set('Authorization', `Bearer ${accessToken}`)
        .set('x-refresh-token', refreshToken)
        .send();

      expect(res.status).toBe(204);

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(sessionsInDb.length).toBe(0);
    });

    it('removes only matching session when multiple sessions exist', async () => {
      await generateTokens(userId);
      await generateTokens(userId);

      const allSessions = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(allSessions.length).toBe(3);

      const res = await api
        .post('/api/v1/auth/logout')
        .set('Authorization', `Bearer ${accessToken}`)
        .set('x-refresh-token', refreshToken)
        .send();

      expect(res.status).toBe(204);

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(sessionsInDb.length).toBe(2);
    });
  });

  describe('POST /auth/refresh', () => {
    let userId: number;
    let accessToken: string;
    let refreshToken: string;
    let passwordHash: string;

    beforeAll(async () => {
      passwordHash = await hash('password123');
    });

    beforeEach(async () => {
      const [user] = await db
        .insert(users)
        .values({
          login: 'refreshUser',
          passwordHash,
        })
        .returning();

      userId = user!.id;

      const tokens = await generateTokens(userId);
      accessToken = tokens.accessToken;
      refreshToken = tokens.refreshToken;
    });

    it('refreshes tokens successfully', async () => {
      const res = await api
        .post('/api/v1/auth/refresh')
        .set('x-refresh-token', refreshToken)
        .send();

      expect(res.status).toBe(200);

      expect(res.body).toHaveProperty('accessToken');
      expect(res.body).toHaveProperty('refreshToken');
      expect(res.body.accessToken).not.toBe(accessToken);
      expect(res.body.refreshToken).not.toBe(refreshToken);
      expect(res.body.accessTokenExpiresAt).toBeDefined();
      expect(res.body.refreshTokenExpiresAt).toBeDefined();

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(sessionsInDb.length).toBe(1);

      const isOldTokenMatching = await verify(
        sessionsInDb[0]!.tokenHash,
        refreshToken,
      );
      expect(isOldTokenMatching).toBe(false);

      const isNewTokenMatching = await verify(
        sessionsInDb[0]!.tokenHash,
        res.body.refreshToken as string,
      );
      expect(isNewTokenMatching).toBe(true);
    });

    it('fails when refresh token does not match any session', async () => {
      await db.delete(sessions).where(eq(sessions.userId, userId));
      await generateTokens(userId);

      const res = await api
        .post('/api/v1/auth/refresh')
        .set('x-refresh-token', refreshToken)
        .send();

      expect(res.status).toBe(401);
      expect(res.body.message).toBe('Invalid or expired refresh token');

      const sessionsInDb = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(sessionsInDb.length).toBe(1);
    });

    it('fails when x-refresh-token header is missing', async () => {
      const res = await api.post('/api/v1/auth/refresh').send();

      expect(res.status).toBe(400);
      expect(res.body).toHaveProperty('message');
      expect(res.body).toHaveProperty('errors');
    });

    it('removes only the matched session when multiple sessions exist', async () => {
      const secondSessionTokens = await generateTokens(userId);
      await generateTokens(userId);

      const initialSessions = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(initialSessions.length).toBe(3);

      const res = await api
        .post('/api/v1/auth/refresh')
        .set('x-refresh-token', refreshToken)
        .send();

      expect(res.status).toBe(200);

      const finalSessions = await db
        .select()
        .from(sessions)
        .where(eq(sessions.userId, userId));

      expect(finalSessions.length).toBe(3);

      let isSecondSessionStillValid = false;
      for (const session of finalSessions) {
        if (await verify(session.tokenHash, secondSessionTokens.refreshToken)) {
          isSecondSessionStillValid = true;
          break;
        }
      }
      expect(isSecondSessionStillValid).toBe(true);
    });
  });
});
