import { z } from '../../extendedZod.js';

export const UserFindOneResDto = z.object({
  id: z.number().int().openapi({ example: 1 }),
  login: z.string().openapi({ example: 'login' }),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

export type UserFindOneResDtoType = z.infer<typeof UserFindOneResDto>;
