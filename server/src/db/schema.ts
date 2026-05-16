import {
  boolean,
  doublePrecision,
  index,
  integer,
  pgEnum,
  pgTable,
  serial,
  text,
  timestamp,
  uuid,
  varchar,
} from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  login: varchar('login', { length: 50 }).notNull().unique(),
  passwordHash: varchar('password_hash', { length: 255 }).notNull(),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const sessions = pgTable('sessions', {
  id: serial('id').primaryKey(),
  userId: integer('user_id')
    .references(() => users.id, {
      onDelete: 'cascade',
    })
    .notNull(),
  tokenHash: varchar('token_hash', { length: 255 }).notNull().unique(),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const taskType = pgEnum('type', ['one_time', 'recurrent']);

export const tasks = pgTable(
  'tasks',
  {
    id: uuid('id').primaryKey(),
    userId: integer('user_id')
      .references(() => users.id, {
        onDelete: 'cascade',
      })
      .notNull(),
    title: text('title').notNull(),
    description: text('description'),
    type: taskType('type').notNull().default(taskType.enumValues[0]),
    completed: boolean('completed').notNull().default(false),
    timeTriggerAt: timestamp('time_trigger_at', { withTimezone: true }),
    geoTriggerLatitude: doublePrecision('geo_trigger_latitude'),
    geoTriggerLongitude: doublePrecision('geo_trigger_longitude'),
    geoTriggerRadius: integer('geo_trigger_radius'),
    createdAt: timestamp('created_at', { withTimezone: true })
      .notNull()
      .defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true })
      .notNull()
      .defaultNow(),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
  },
  (table) => [
    index('user_idx').on(table.userId),
    index('deleted_at_idx').on(table.deletedAt),
  ],
);
