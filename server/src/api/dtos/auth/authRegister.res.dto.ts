import { z } from 'zod';
import { UserFindOneResDto } from '../users/userFindOne.res.dto.js';

export const AuthRegisterResDto = z.object({
  user: UserFindOneResDto,
  accessToken: z.string(),
  refreshToken: z.string(),
  accessTokenExpiresAt: z.string().datetime(),
  refreshTokenExpiresAt: z.string().datetime(),
});

export type AuthRegisterResDtoType = z.infer<typeof AuthRegisterResDto>;
