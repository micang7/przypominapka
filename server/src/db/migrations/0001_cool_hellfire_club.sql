ALTER TABLE "sessions" ADD COLUMN "device_id" text NOT NULL;--> statement-breakpoint
ALTER TABLE "sessions" ADD COLUMN "fcm_token" text;