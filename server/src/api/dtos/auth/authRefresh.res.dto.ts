import { z } from 'zod';

export const AuthRefreshResDto = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
  accessTokenExpiresAt: z.string().datetime(),
  refreshTokenExpiresAt: z.string().datetime(),
});

export type AuthRefreshResDtoType = z.infer<typeof AuthRefreshResDto>;
