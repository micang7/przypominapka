import z from 'zod';
import { taskType } from '../../../../db/schema.js';

export const PushedUpdatedTaskDto = z.object({
  id: z.string().uuid(),
  title: z.string().min(1).optional(),
  description: z.string().nullish(),
  type: z.enum(taskType.enumValues).optional(),
  completed: z.boolean().optional(),
  timeTriggerAt: z.string().datetime().nullish(),
  geoTriggerLatitude: z.number().min(-90).max(90).nullish(),
  geoTriggerLongitude: z.number().min(-180).max(180).nullish(),
  geoTriggerRadius: z.number().int().positive().max(50000).nullish(),
});

export type PushedUpdatedTaskDtoType = z.infer<typeof PushedUpdatedTaskDto>;
