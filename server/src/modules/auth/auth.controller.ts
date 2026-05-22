import { s } from '../../config/tsRestServer.js';
import { apiContract } from '../../api/apiContract.js';
import { authService } from './auth.service.js';

export const authController = s.router(apiContract.auth, {
  register: async ({ body }) => {
    const result = await authService.register(body);
    return {
      status: 201,
      body: result,
    };
  },
  login: async () => {
    await Promise.resolve();
    return {
      status: 200,
      body: {
        user: {
          id: 1,
          login: 'login',
          createdAt: '2026-05-17T13:22:37.400Z',
          updatedAt: '2026-05-17T13:22:37.400Z',
        },
        accessToken: 'string',
        refreshToken: 'string',
        accessTokenExpiresAt: '2026-05-17T13:22:37.400Z',
        refreshTokenExpiresAt: '2026-05-17T13:22:37.400Z',
      },
    };
  },
  logout: async () => {
    await Promise.resolve();
    return { status: 204, body: undefined };
  },
  refresh: async () => {
    await Promise.resolve();
    return {
      status: 200,
      body: {
        accessToken: 'string',
        refreshToken: 'string',
        accessTokenExpiresAt: '2026-05-17T13:22:37.400Z',
        refreshTokenExpiresAt: '2026-05-17T13:22:37.400Z',
      },
    };
  },
});
