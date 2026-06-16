import z from 'zod';
import { taskType } from '../../../../db/schema.js';

export const PulledCreatedTaskDto = z.object({
  id: z.string().uuid(),
  title: z.string().min(1),
  description: z.string().nullish(),
  type: z.enum(taskType.enumValues),
  timeTriggerAt: z.string().datetime().nullish(),
  geoTriggerLatitude: z.number().min(-90).max(90).nullish(),
  geoTriggerLongitude: z.number().min(-180).max(180).nullish(),
  geoTriggerRadius: z.number().int().positive().max(50000).nullish(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

export type PulledCreatedTaskDtoType = z.infer<typeof PulledCreatedTaskDto>;
