import z from 'zod';
import { PushedCreatedTaskDto } from './tasks/pushedCreatedTask.dto.js';
import { PushedUpdatedTaskDto } from './tasks/pushedUpdatedTask.dto.js';
import { DeletedTaskDto } from './tasks/DeletedTask.dto.js';

export const SyncDto = z.object({
  last_sync_at: z.string().datetime(),
  changes: z.object({
    created: z.array(PushedCreatedTaskDto),
    updated: z.array(PushedUpdatedTaskDto),
    deleted: z.array(DeletedTaskDto),
  }),
});

export type SyncDtoType = z.infer<typeof SyncDto>;
