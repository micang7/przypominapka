import pino from 'pino';
import type { LoggerOptions } from 'pino';
import { env } from './env.js';

const pinoOptions: LoggerOptions = {
  level: env.LOG_LEVEL,
  base: null,
};

if (env.NODE_ENV !== 'production') {
  pinoOptions.transport = {
    target: 'pino-pretty',
    options: {
      colorize: true,
      translateTime: 'SYS:standard',
      ignore: 'req,res,responseTime,scope',
      messageFormat: '[{scope}] {msg}',
    },
  };
}

const logger = pino(pinoOptions);

export const appLogger = logger.child({ scope: 'app' });
export const httpLogger = logger.child({ scope: 'http' });
