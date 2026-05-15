import pino from 'pino';
import type { LoggerOptions } from 'pino';
import { env } from './env.js';

const pinoOptions: LoggerOptions = {
  level: env.LOG_LEVEL || 'info',
};

if (env.NODE_ENV !== 'production') {
  pinoOptions.transport = {
    target: 'pino-pretty',
    options: {
      colorize: true,
      translateTime: 'HH:MM:ss Z',
      ignore: 'pid,hostname',
    },
  };
}

export const logger = pino(pinoOptions);
