import type { Request, Response, NextFunction } from 'express';
import type { AppError } from '../utils/appErrors.js';

export function errorHandler(
  err: AppError,
  _req: Request,
  res: Response,
  _next: NextFunction,
) {
  if (err.isOperational) {
    res.status(err.statusCode).json({
      message: err.message,
      ...(err.errors && { errors: err.errors }),
      ...(err.paths && { paths: err.paths }),
    });
  } else {
    console.error(err);
    res.status(500).json({
      message: 'Internal Server Error',
    });
  }
}
