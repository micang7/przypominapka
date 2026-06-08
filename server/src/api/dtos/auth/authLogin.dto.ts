import { z } from '../../extendedZod.js';

export const AuthLoginDto = z.object({
  login: z.string().min(3).max(50).trim().openapi({ example: 'login' }),
  password: z.string().min(1).max(255).openapi({ example: 'password' }),
  deviceId: z.string().min(1),
  fcmToken: z.string().optional(),
});

export type AuthLoginDtoType = z.infer<typeof AuthLoginDto>;
