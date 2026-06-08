import { pinoHttp } from 'pino-http';
import { httpLogger } from './logger.js';
import { randomUUID } from 'crypto';
import type { Request, Response } from 'express';

export const reqLogger = pinoHttp({
  logger: httpLogger,

  genReqId: (req) => (req.headers['x-request-id'] as string) ?? randomUUID(),

  customLogLevel: (_req, res, err) => {
    if (err || res.statusCode >= 500) return 'error';
    if (res.statusCode >= 400) return 'warn';
    return 'info';
  },

  redact: [
    'req.headers.authorization',
    'req.headers.cookie',
    'req.body.password',
    'req.body.token',
  ],

  serializers: {
    req: (req: Request) => ({
      id: req.id,
      method: req.method,
      url: req.url,
      headers: {
        host: req.headers.host,
        userAgent: req.headers['user-agent'],
      },
    }),
    res: (res: Response) => ({
      statusCode: res.statusCode,
    }),
  },

  customSuccessMessage: (req: Request, res: Response) =>
    `${res.statusCode} ${req.method} ${req.originalUrl}`,

  customErrorMessage: (req: Request, res: Response) =>
    `${res.statusCode} ${req.method} ${req.originalUrl}`,

  autoLogging: {
    ignore: (req) =>
      /\.(js|css|png|jpg|ico|svg|map)$/.test(req.originalUrl ?? ''),
  },
});
