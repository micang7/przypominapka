import { z } from '../../extendedZod.js';
import { ErrorResDto } from './error.res.dto.js';

export const ValidationError = z.object({
  path: z.string().openapi({ example: 'login' }),
  code: z.string().openapi({ example: 'too_short' }),
  error: z
    .string()
    .openapi({ example: 'String must contain at least 3 character(s)' }),
});

export const ValidationErrorResDto = ErrorResDto.extend({
  validationErrors: z.array(ValidationError),
});

export type ValidationErrorResDtoType = z.infer<typeof ValidationErrorResDto>;
