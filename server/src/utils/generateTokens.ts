import jwt from 'jsonwebtoken';
import { hash } from 'argon2';
import { env } from '../config/env.js';
import { db } from '../db/client.js';
import { sessions } from '../db/schema.js';

export async function generateTokens(userId: number) {
  const accessToken = jwt.sign({ userId }, env.JWT_SECRET, {
    expiresIn: env.JWT_EXPIRES_IN,
  });

  const refreshToken = jwt.sign({ userId }, env.JWT_REFRESH_SECRET, {
    expiresIn: env.JWT_REFRESH_EXPIRES_IN,
  });

  const tokenHash = await hash(refreshToken);
  await db.insert(sessions).values({
    userId,
    tokenHash,
  });

  const decodedAccess = jwt.decode(accessToken) as jwt.JwtPayload;
  const decodedRefresh = jwt.decode(refreshToken) as jwt.JwtPayload;

  const accessExpiresAt = decodedAccess?.exp
    ? new Date(decodedAccess.exp * 1000)
    : new Date();
  const refreshExpiresAt = decodedRefresh?.exp
    ? new Date(decodedRefresh.exp * 1000)
    : new Date();

  return {
    accessToken,
    refreshToken,
    accessTokenExpiresAt: accessExpiresAt.toISOString(),
    refreshTokenExpiresAt: refreshExpiresAt.toISOString(),
  };
}
