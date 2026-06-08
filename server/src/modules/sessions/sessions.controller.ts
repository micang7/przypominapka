import { s } from '../../config/tsRestServer.js';
import { apiContract } from '../../api/apiContract.js';
import { sessionsService } from './sessions.service.js';

export const sessionsController = s.router(apiContract.sessions, {
  updateFcmToken: async ({ body, req }) => {
    const userId = req.userId!;
    await sessionsService.updateFcmToken(userId, body);
    return {
      status: 204,
      body: undefined,
    };
  },
});
