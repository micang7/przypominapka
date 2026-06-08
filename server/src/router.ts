import { s } from './config/tsRestServer.js';
import { apiContract } from './api/apiContract.js';
import { authController } from './modules/auth/auth.controller.js';
import { usersController } from './modules/users/users.controller.js';
import { syncController } from './modules/sync/sync.controller.js';
import { sessionsController } from './modules/sessions/sessions.controller.js';

export const router = s.router(apiContract, {
  auth: authController,
  users: usersController,
  sync: syncController,
  sessions: sessionsController,
});
