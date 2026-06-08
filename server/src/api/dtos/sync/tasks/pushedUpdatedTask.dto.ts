import z from 'zod';
import { taskType } from '../../../../db/schema.js';

export const PushedUpdatedTaskDto = z.object({
  id: z.string().uuid(),
  title: z.string().min(1).optional(),
  description: z.string().nullish(),
  type: z.enum(taskType.enumValues).optional(),
  completed: z.boolean().optional(),
  timeTriggerAt: z.string().datetime().nullish(),
  geoTriggerLatitude: z.number().nullish(),
  geoTriggerLongitude: z.number().nullish(),
  geoTriggerRadius: z.number().int().positive().nullish(),
});

export type PushedUpdatedTaskDtoType = z.infer<typeof PushedUpdatedTaskDto>;
