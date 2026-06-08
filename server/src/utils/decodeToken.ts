import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';
import { UnauthorizedError } from './appErrors.js';

export function decodeToken(token: string, type: 'access' | 'refresh'): number {
  try {
    return (
      jwt.verify(
        token,
        type === 'access' ? env.JWT_SECRET : env.JWT_REFRESH_SECRET,
      ) as { userId: number; jti: string }
    ).userId;
  } catch {
    throw new UnauthorizedError('Invalid or expired token');
  }
}
