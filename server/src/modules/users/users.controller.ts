import { s } from '../../config/tsRestServer.js';
import { apiContract } from '../../api/apiContract.js';

export const usersController = s.router(apiContract.users, {
  getMe: async () => {
    await Promise.resolve();
    return {
      status: 200,
      body: {
        id: 1,
        login: 'login',
        createdAt: '2026-05-17T14:12:50.852Z',
        updatedAt: '2026-05-17T14:12:50.852Z',
      },
    };
  },
  deleteMe: async () => {
    await Promise.resolve();
    return { status: 204, body: undefined };
  },
});
