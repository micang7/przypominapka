import { migrate } from 'drizzle-orm/postgres-js/migrator';
import postgres from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';
import { env } from '../../config/env.js';

const runMigration = async () => {
  const client = postgres(env.DATABASE_URL, { max: 1, onnotice: () => {} });
  const db = drizzle(client);
  try {
    await migrate(db, { migrationsFolder: 'dist/db/migrations' });
  } finally {
    await client.end();
  }
};

await runMigration();
