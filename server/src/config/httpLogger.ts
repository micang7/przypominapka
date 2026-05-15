import { pinoHttp } from 'pino-http';
import { logger } from './logger.js';

export const httpLogger = pinoHttp({
  logger,
  serializers: {
    req: () => undefined,
    res: () => undefined,
    err: () => undefined,
    responseTime: () => undefined,
  },
  customSuccessMessage: (req, res, responseTime) => {
    return `${req.method} ${req.url} ${res.statusCode} - ${responseTime}ms`;
  },
  customErrorMessage: (req, res, err) => {
    return `${req.method} ${req.url} ${res.statusCode} - ERROR: ${err.message}`;
  },
  autoLogging: {
    ignore: (req) => /\.(js|css|png|jpg|ico|svg|map)$/.test(req.url ?? ''),
  },
});
