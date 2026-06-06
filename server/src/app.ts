import express from 'express';
import swaggerUi from 'swagger-ui-express';
import { openApiDocument } from './api/openApi.js';
import { errorHandler } from './middleware/errorHandler.js';
import { BadRequestError, NotFoundError } from './utils/appErrors.js';
import { appLogger } from './config/logger.js';
import { reqLogger } from './config/httpLogger.js';
import { createExpressEndpoints } from '@ts-rest/express';
import { apiContract } from './api/apiContract.js';
import { router } from './router.js';
import { jwtAuth } from './middleware/jwtAuth.js';
import cors from 'cors';

export const app = express();

app.use(cors());

app.use(express.json());

app.use(reqLogger);

createExpressEndpoints(apiContract, router, app, {
  globalMiddleware: [
    (req, res, next) => {
      if (
        'metadata' in req.tsRestRoute &&
        req.tsRestRoute.metadata &&
        req.tsRestRoute.metadata.security.some((s) => 'bearerAuth' in s)
      ) {
        return jwtAuth(req, res, next);
      }
      next();
    },
  ],
  requestValidationErrorHandler(err, _req, _res, next) {
    const errors = [
      ...(err.pathParams?.issues ?? []).map((issue) => ({
        path: `params.${issue.path.join('.')}`,
        code: issue.code,
        error: issue.message,
      })),
      ...(err.query?.issues ?? []).map((issue) => ({
        path: `query.${issue.path.join('.')}`,
        code: issue.code,
        error: issue.message,
      })),
      ...(err.body?.issues ?? []).map((issue) => ({
        path: `body.${issue.path.join('.')}`,
        code: issue.code,
        error: issue.message,
      })),
    ];
    next(new BadRequestError(errors));
  },
});

app.use('/api/v1/docs/ui', swaggerUi.serve, swaggerUi.setup(openApiDocument));

app.get('/api/v1/docs/openapi.json', (_req, res) => res.json(openApiDocument));

app.use((_req, _res, next) => next(new NotFoundError()));

app.use(errorHandler);

process.on('uncaughtException', (err) => {
  appLogger.error({ err }, 'Uncaught Exception');
  process.exit(1);
});

process.on('unhandledRejection', (err) => {
  appLogger.error({ err }, 'Unhandled Promise Rejection');
  process.exit(1);
});
