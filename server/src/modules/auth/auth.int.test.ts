import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import { db } from '../../db/client.js';
import { users } from '../../db/schema.js';
import { app } from '../../app.js';
import { sql } from 'drizzle-orm';
import { hash } from 'argon2';

describe('Auth Module', () => {
  const api = request(app);

  beforeEach(async () => {
    await db.execute(sql`TRUNCATE TABLE users RESTART IDENTITY CASCADE`);
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
});
