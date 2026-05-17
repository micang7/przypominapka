import { generateOpenApi } from '@ts-rest/open-api';
import { apiContract } from './apiContract.js';
import type { OpenAPIV3 } from 'openapi-types';

const hasSecurity = (
  metadata: unknown,
): metadata is { security: OpenAPIV3.SecurityRequirementObject[] } =>
  !!metadata && typeof metadata === 'object' && 'security' in metadata;

export const openApiDocument = generateOpenApi(
  apiContract,
  {
    info: { title: 'Przypominapka API', version: '1.0.0' },
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          description:
            'Wpisz swój token JWT, aby uzyskać dostęp do chronionych endpointów',
        },
      },
    },
  },
  {
    setOperationId: true,
    operationMapper: (operation, route) => ({
      ...operation,
      ...(hasSecurity(route.metadata)
        ? {
            security: route.metadata.security,
          }
        : {}),
    }),
  },
);
