import { z } from 'zod';

export const ErrorResDto = z.object({
  message: z.string(),
});

export type ErrorResDtoType = z.infer<typeof ErrorResDto>;
