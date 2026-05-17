import z from 'zod';
import { taskType } from '../../../../db/schema.js';

export const PulledCreatedTaskDto = z.object({
  id: z.string().uuid(),
  title: z.string().min(1),
  description: z.string().nullish(),
  type: z.enum(taskType.enumValues),
  timeTriggerAt: z.string().datetime().nullish(),
  geoTriggerLatitude: z.number().nullish(),
  geoTriggerLongitude: z.number().nullish(),
  geoTriggerRadius: z.number().int().positive().nullish(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

export type PulledCreatedTaskDtoType = z.infer<typeof PulledCreatedTaskDto>;
