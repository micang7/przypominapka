import { z } from '../../extendedZod.js';

export const AuthChangePasswordDto = z
  .object({
    oldPassword: z
      .string()
      .min(1)
      .max(255)
      .openapi({ example: 'old-password' }),
    newPassword: z
      .string()
      .min(1)
      .max(255)
      .openapi({ example: 'new-password' }),
    newConfirmPassword: z
      .string()
      .min(1)
      .max(255)
      .openapi({ example: 'new-password' }),
  })
  .refine((data) => data.newPassword === data.newConfirmPassword, {
    message: 'Passwords do not match',
    path: ['newConfirmPassword'],
    params: { subCode: 'password_mismatch' },
  })
  .transform(({ newConfirmPassword: _, ...data }) => data);

export type AuthChangePasswordDtoType = z.infer<typeof AuthChangePasswordDto>;
