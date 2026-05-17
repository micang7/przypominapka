import express from 'express';
import swaggerUi from 'swagger-ui-express';
import { openApiDocument } from './api/openApi.js';
import { errorHandler } from './middleware/errorHandler.js';
import { NotFoundError } from './utils/appErrors.js';
import { logger } from './config/logger.js';
import { httpLogger } from './config/httpLogger.js';

export const app = express();

app.use(express.json());

app.use(httpLogger);

app.get('/api/v1', (_req, res) => {
  res.status(200).json({
    message: 'AMDG',
  });
});

app.use('/api/v1/docs/ui', swaggerUi.serve, swaggerUi.setup(openApiDocument));

app.get('/api/v1/docs/openapi.json', (_req, res) => res.json(openApiDocument));

app.use((_req, _res, next) => next(new NotFoundError()));

app.use(errorHandler);

process.on('uncaughtException', (err: Error) => {
  logger.error(`Uncaught Exception: ${err.message}`);
  process.exit(1);
});

process.on('unhandledRejection', (err: Error) => {
  logger.error(`Unhandled Promise Rejection: ${err.message}`);
  process.exit(1);
});
