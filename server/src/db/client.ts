import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import { env } from '../env.js';
import * as schema from './schema.js';

const client = postgres({
  host: env.POSTGRES_HOST,
  port: env.POSTGRES_PORT,
  user: env.POSTGRES_USER,
  password: env.POSTGRES_PASSWORD,
  database: env.POSTGRES_DB,
  max: 10,
  idle_timeout: 10,
  connect_timeout: 5,
});

export const db = drizzle(client, {
  schema,
  logger: env.NODE_ENV === 'development',
});

export type DbClient = typeof db;
