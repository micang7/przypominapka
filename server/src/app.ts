import express from 'express';
import swaggerUi from 'swagger-ui-express';
import { openApiDocument } from './api/openApi.js';
import { errorHandler } from './middleware/errorHandler.js';
import { NotFoundError } from './utils/appErrors.js';
import { appLogger } from './config/logger.js';
import { reqLogger } from './config/httpLogger.js';
import { createExpressEndpoints } from '@ts-rest/express';
import { apiContract } from './api/apiContract.js';
import { router } from './router.js';

export const app = express();

app.use(express.json());

app.use(reqLogger);

createExpressEndpoints(apiContract, router, app);

app.use('/api/v1/docs/ui', swaggerUi.serve, swaggerUi.setup(openApiDocument));

app.get('/api/v1/docs/openapi.json', (_req, res) => res.json(openApiDocument));

app.use((_req, _res, next) => next(new NotFoundError()));

app.use(errorHandler);

process.on('uncaughtException', (error) => {
  appLogger.error({ error }, 'Uncaught Exception');
  process.exit(1);
});

process.on('unhandledRejection', (error) => {
  appLogger.error({ error }, 'Unhandled Promise Rejection');
  process.exit(1);
});
