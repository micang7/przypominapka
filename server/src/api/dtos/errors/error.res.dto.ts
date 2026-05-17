import { z } from '../../extendedZod.js';

export const ErrorResDto = z.object({
  message: z.string().openapi({ example: 'error message' }),
});

export type ErrorResDtoType = z.infer<typeof ErrorResDto>;
