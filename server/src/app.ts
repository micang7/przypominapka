import express from 'express';
import swaggerUi from 'swagger-ui-express';
import { openApiDocument } from './api/openApi.js';

export const app = express();

app.use(express.json());

app.get('/api/v1', (_req, res) => {
  res.status(200).json({
    message: 'AMDG',
  });
});

app.use('/api/v1/docs/ui', swaggerUi.serve, swaggerUi.setup(openApiDocument));

app.get('/api/v1/docs/openapi.json', (_req, res) => res.json(openApiDocument));
