import { migrate } from 'drizzle-orm/postgres-js/migrator';
import postgres from 'postgres';
import { dbConnOptions } from '../client.js';
import { drizzle } from 'drizzle-orm/postgres-js';

const runMigration = async () => {
  const client = postgres({ ...dbConnOptions, max: 1 });
  const db = drizzle(client);
  try {
    await migrate(db, { migrationsFolder: 'dist/db/migrations' });
  } finally {
    await client.end();
  }
};

await runMigration();
