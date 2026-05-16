import z from 'zod';

export const DeletedTaskDto = z.object({
  id: z.string().uuid(),
});

export type DeletedTaskDtoType = z.infer<typeof DeletedTaskDto>;
