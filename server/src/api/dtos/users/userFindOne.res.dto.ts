import { z } from 'zod';

export const UserFindOneResDto = z.object({
  id: z.number().int(),
  login: z.string(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

export type UserFindOneResDtoType = z.infer<typeof UserFindOneResDto>;
