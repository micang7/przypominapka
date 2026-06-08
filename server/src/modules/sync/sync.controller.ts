import { s } from '../../config/tsRestServer.js';
import { apiContract } from '../../api/apiContract.js';
import { syncService } from './sync.service.js';

export const syncController = s.router(apiContract.sync, {
  sync: async ({ body, req }) => {
    const userId = req.userId!;

    const result = await syncService.sync(userId, body);

    return {
      status: 200,
      body: result,
    };
  },
});
