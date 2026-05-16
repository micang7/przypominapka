import { z } from 'zod';
import { ErrorResDto } from './error.res.dto.js';

export const ValidationError = z.object({
  path: z.string(),
  code: z.string(),
  error: z.string(),
});

export const ValidationErrorResDto = ErrorResDto.extend({
  validationErrors: z.array(ValidationError),
});

export type ValidationErrorResDtoType = z.infer<typeof ValidationErrorResDto>;
