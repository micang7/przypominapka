import type { Request, Response, NextFunction } from 'express';
import { UnauthorizedError } from '../utils/appErrors.js';
import { decodeToken } from '../utils/decodeToken.js';

declare module 'express-serve-static-core' {
  interface Request {
    userId?: number;
  }
}

export function jwtAuth(req: Request, _res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next(new UnauthorizedError('Missing or malformed token'));
  }

  const token = authHeader.split(' ')[1]!;

  req.userId = decodeToken(token, 'access');
  next();
}
