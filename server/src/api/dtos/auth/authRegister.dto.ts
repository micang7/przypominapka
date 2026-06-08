import { z } from '../../extendedZod.js';

export const AuthRegisterDto = z
  .object({
    login: z.string().min(3).max(50).trim().openapi({ example: 'login' }),
    password: z.string().min(1).max(255).openapi({ example: 'password' }),
    confirmPassword: z
      .string()
      .min(1)
      .max(255)
      .openapi({ example: 'password' }),
    deviceId: z.string().min(1),
    fcmToken: z.string().optional(),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: 'Passwords do not match',
    path: ['confirmPassword'],
    params: { subCode: 'password_mismatch' },
  })
  .transform(({ confirmPassword: _, ...data }) => data);

export type AuthRegisterDtoType = z.infer<typeof AuthRegisterDto>;
