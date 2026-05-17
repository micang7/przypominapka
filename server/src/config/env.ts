import 'dotenv/config';
import type { StringValue } from 'ms';
import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z
    .enum(['development', 'production', 'test'])
    .default('development'),
  LOG_LEVEL: z
    .enum(['trace', 'debug', 'info', 'warn', 'error', 'fatal', 'silent'])
    .default('info'),
  PORT: z.coerce.number().default(3000),
  POSTGRES_HOST: z.string(),
  POSTGRES_PORT: z.coerce.number(),
  POSTGRES_DB: z.string(),
  POSTGRES_USER: z.string(),
  POSTGRES_PASSWORD: z.string(),
  JWT_SECRET: z.string(),
  JWT_REFRESH_SECRET: z.string(),
  JWT_EXPIRES_IN: z.string() as z.ZodType<StringValue>,
  JWT_REFRESH_EXPIRES_IN: z.string() as z.ZodType<StringValue>,
});

export const env = envSchema.parse(process.env);

export type Env = z.infer<typeof envSchema>;
