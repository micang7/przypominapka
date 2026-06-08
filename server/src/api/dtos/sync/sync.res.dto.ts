import z from 'zod';
import { PulledCreatedTaskDto } from './tasks/pulledCreatedTask.dto.js';
import { PulledUpdatedTaskDto } from './tasks/pulledUpdatedTask.dto.js';
import { DeletedTaskDto } from './tasks/DeletedTask.dto.js';

export const SyncResDto = z.object({
  sync_at: z.string().datetime(),
  changes: z.object({
    created: z.array(PulledCreatedTaskDto),
    updated: z.array(PulledUpdatedTaskDto),
    deleted: z.array(DeletedTaskDto),
  }),
});

export type SyncResDtoType = z.infer<typeof SyncResDto>;
