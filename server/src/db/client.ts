import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import { env } from '../config/env.js';
import * as schema from './schema.js';
import { appLogger } from '../config/logger.js';
import { sql } from 'drizzle-orm';

export const dbConnOptions = {
  host: env.POSTGRES_HOST,
  port: env.POSTGRES_PORT,
  user: env.POSTGRES_USER,
  password: env.POSTGRES_PASSWORD,
  database: env.POSTGRES_DB,
  onnotice: () => {},
};

const client = postgres({
  ...dbConnOptions,
  max: 10,
  idle_timeout: 10,
  connect_timeout: 5,
});

export const db = drizzle(client, { schema });

export type DbClient = typeof db;

export async function checkDbConnWithRetry({
  retries = 5,
  delayMs = 1000,
  factor = 2,
}: {
  retries?: number;
  delayMs?: number;
  factor?: number;
} = {}) {
  let attempt = 0;
  let currentDelay = delayMs;

  while (attempt < retries) {
    try {
      await db.execute(sql`SELECT 1;`);
      appLogger.info('Database connected');
      return;
    } catch (error) {
      attempt++;

      if (attempt >= retries) {
        throw error;
      }

      appLogger.warn(
        `Database connection failed (attempt ${attempt}/${retries}). Retrying in ${currentDelay / 1000}s...`,
      );

      await new Promise((r) => setTimeout(r, currentDelay));
      currentDelay *= factor;
    }
  }
}
