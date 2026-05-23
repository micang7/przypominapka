import type { ValidationErrorType } from '../api/dtos/errors/validationError.res.dto.js';

export class AppError extends Error {
  public statusCode: number;
  public errors?: ValidationErrorType[];
  public paths?: string[];

  constructor(message: string, statusCode: number) {
    super(message);
    this.statusCode = statusCode;

    Object.setPrototypeOf(this, new.target.prototype);

    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, this.constructor);
    }
  }
}

export class BadRequestError extends AppError {
  constructor(errors: ValidationErrorType[], message = 'Validation failed') {
    super(message, 400);
    this.errors = errors;
  }
}

export class UnauthorizedError extends AppError {
  constructor(message = 'Unauthorized') {
    super(message, 401);
  }
}

export class NotFoundError extends AppError {
  constructor(message = 'Not found') {
    super(message, 404);
  }
}

export class ConflictError extends AppError {
  constructor(message = 'Conflict with existing data', paths: string[] = []) {
    super(message, 409);
    this.paths = paths;
  }
}
