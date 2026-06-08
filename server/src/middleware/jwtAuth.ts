import type { Request, Response, NextFunction } from 'express';
import { UnauthorizedError } from '../utils/appErrors.js';
import { decodeToken } from '../utils/decodeToken.js';
import { db } from '../db/client.js';
import { eq } from 'drizzle-orm';
import { users } from '../db/schema.js';
import { appLogger } from '../config/logger.js';

declare module 'express-serve-static-core' {
  interface Request {
    userId?: number;
  }
}

export async function jwtAuth(
  req: Request,
  _res: Response,
  next: NextFunction,
) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next(new UnauthorizedError('Missing or malformed token'));
  }

  const token = authHeader.split(' ')[1]!;

  const userId = decodeToken(token, 'access');

  const user = await db.query.users.findFirst({
    where: eq(users.id, userId),
  });

  if (!user) {
    appLogger.warn({ userId }, 'User not found during JWT authentication');
    return next(new UnauthorizedError('User does not exist'));
  }

  req.userId = userId;

  next();
}
