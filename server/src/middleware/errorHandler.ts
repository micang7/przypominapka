import type { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/appErrors.js';
import { appLogger } from '../config/logger.js';

export function errorHandler(
  err: unknown,
  _req: Request,
  res: Response,
  _next: NextFunction,
) {
  if (err instanceof AppError) {
    res.status(err.statusCode).json({
      message: err.message,
      ...(err.errors && { errors: err.errors }),
      ...(err.paths && { paths: err.paths }),
    });
  } else {
    appLogger.error({ error: err }, 'Unexpected error');
    res.status(500).json({
      message: 'Internal Server Error',
    });
  }
}
