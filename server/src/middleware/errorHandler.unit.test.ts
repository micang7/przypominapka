import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { Request, Response, NextFunction } from 'express';
import { errorHandler } from './errorHandler.js';
import { appLogger } from '../config/logger.js';
import {
  BadRequestError,
  ConflictError,
  NotFoundError,
  UnauthorizedError,
} from '../utils/appErrors.js';

vi.mock('../config/logger.js', () => ({
  appLogger: {
    error: vi.fn(),
  },
}));

type MockResponse = Pick<Response, 'status' | 'json'>;

const createResponseMock = (): MockResponse => ({
  status: vi.fn().mockReturnThis(),
  json: vi.fn().mockReturnThis(),
});

const createNextMock = (): NextFunction => vi.fn();

describe('errorHandler', () => {
  let res: MockResponse;
  let next: NextFunction;

  beforeEach(() => {
    vi.clearAllMocks();

    res = createResponseMock();
    next = createNextMock();
  });

  describe('AppError handling', () => {
    it.each([
      [
        'UnauthorizedError',
        new UnauthorizedError(),
        401,
        {
          message: 'Unauthorized',
        },
      ],
      [
        'NotFoundError',
        new NotFoundError(),
        404,
        {
          message: 'Not found',
        },
      ],
      [
        'BadRequestError',
        new BadRequestError([
          {
            path: 'login',
            code: 'too_short',
            error: 'String must contain at least 3 character(s)',
          },
        ]),
        400,
        {
          message: 'Validation failed',
          errors: [
            {
              path: 'login',
              code: 'too_short',
              error: 'String must contain at least 3 character(s)',
            },
          ],
        },
      ],
      [
        'ConflictError',
        new ConflictError('Login already in use', ['login']),
        409,
        {
          message: 'Login already in use',
          paths: ['login'],
        },
      ],
    ])(
      'returns proper response for %s',
      (_name, error, expectedStatus, expectedPayload) => {
        errorHandler(error, {} as Request, res as Response, next);

        expect(res.status).toHaveBeenCalledExactlyOnceWith(expectedStatus);
        expect(res.json).toHaveBeenCalledExactlyOnceWith(expectedPayload);
        expect(appLogger.error).not.toHaveBeenCalled();
      },
    );
  });

  describe('unknown error handling', () => {
    it('returns 500 and logs error', () => {
      const error = new Error('database crash');

      errorHandler(error, {} as Request, res as Response, next);

      expect(res.status).toHaveBeenCalledExactlyOnceWith(500);
      expect(res.json).toHaveBeenCalledExactlyOnceWith({
        message: 'Internal Server Error',
      });
      expect(appLogger.error).toHaveBeenCalled();
    });
  });
});
