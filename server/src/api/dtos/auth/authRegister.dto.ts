import { z } from 'zod';

export const AuthRegisterDto = z
  .object({
    login: z.string().min(3).max(50).trim(),
    password: z.string().min(1).max(255),
    confirmPassword: z.string().min(1).max(255),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: 'Passwords do not match',
    path: ['confirmPassword'],
    params: { subCode: 'password_mismatch' },
  });

export type AuthRegisterDtoType = z.infer<typeof AuthRegisterDto>;
