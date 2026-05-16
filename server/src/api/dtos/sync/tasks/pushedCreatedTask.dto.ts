import z from 'zod';
import { taskType } from '../../../../db/schema.js';

export const PushedCreatedTaskDto = z.object({
  id: z.string().uuid(),
  title: z.string().min(1),
  description: z.string().nullish(),
  type: z.enum(taskType.enumValues),
  timeTriggerAt: z.string().datetime().nullish(),
  geoTriggerLatitude: z.number().nullish(),
  geoTriggerLongitude: z.number().nullish(),
  geoTriggerRadius: z.number().int().positive().nullish(),
});

export type PushedCreatedTaskDtoType = z.infer<typeof PushedCreatedTaskDto>;
