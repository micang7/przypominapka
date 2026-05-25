import { s } from '../../config/tsRestServer.js';
import { apiContract } from '../../api/apiContract.js';
import { authService } from './auth.service.js';
import { UnauthorizedError } from '../../utils/appErrors.js';

export const authController = s.router(apiContract.auth, {
  register: async ({ body }) => {
    const result = await authService.register(body);
    return {
      status: 201,
      body: result,
    };
  },
  login: async ({ body }) => {
    const result = await authService.login(body);
    return {
      status: 200,
      body: result,
    };
  },
  logout: async ({ headers, req }) => {
    const userId = req.userId!;
    const refreshToken = headers['x-refresh-token'];

    if (!refreshToken) {
      throw new UnauthorizedError('Missing refresh token header for logout');
    }
    await authService.logout(userId, refreshToken);

    return {
      status: 204,
      body: undefined,
    };
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
