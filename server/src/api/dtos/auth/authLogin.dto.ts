import { z } from 'zod';

export const AuthLoginDto = z.object({
  login: z.string().min(3).max(50).trim(),
  password: z.string().min(1).max(255),
});

export type AuthLoginDtoType = z.infer<typeof AuthLoginDto>;
