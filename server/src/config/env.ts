import dotenv from 'dotenv';
dotenv.config({
  path: process.env.NODE_ENV === 'test' ? '.env.test' : '.env',
  override: true,
});
import type { StringValue } from 'ms';
import pino from 'pino';
import { z } from 'zod';

const bootLogger = pino({ level: process.env.LOG_LEVEL || 'info' });

const envSchema = z.object({
  NODE_ENV: z
    .enum(['development', 'production', 'test'])
    .default('development'),
  LOG_LEVEL: z
    .enum(['trace', 'debug', 'info', 'warn', 'error', 'fatal', 'silent'])
    .default('info'),
  PORT: z.coerce.number().int().positive().default(3000),
  DATABASE_URL: z.string().url().min(1),
  JWT_SECRET: z.string().min(1),
  JWT_REFRESH_SECRET: z.string().min(1),
  JWT_EXPIRES_IN: z.custom<StringValue>(),
  JWT_REFRESH_EXPIRES_IN: z.custom<StringValue>(),
});

const result = envSchema.safeParse(process.env);

if (!result.success) {
  bootLogger.fatal(
    { missingVariables: result.error.flatten().fieldErrors },
    'Missing or invalid environment variables',
  );
  process.exit(1);
}

export const env = result.data;

export type Env = z.infer<typeof envSchema>;
