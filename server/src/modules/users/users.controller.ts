import { s } from '../../config/tsRestServer.js';
import { apiContract } from '../../api/apiContract.js';
import { usersService } from './users.service.js';

export const usersController = s.router(apiContract.users, {
  getMe: async ({ req }) => {
    const userId = req.userId!;

    const result = await usersService.findOne(userId);

    return {
      status: 200,
      body: result,
    };
  },
  deleteMe: async () => {
    await Promise.resolve();
    return { status: 204, body: undefined };
  },
});
