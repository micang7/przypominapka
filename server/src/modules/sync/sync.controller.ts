import { s } from '../../config/tsRestServer.js';
import { apiContract } from '../../api/apiContract.js';

export const syncController = s.router(apiContract.sync, {
  sync: async () => {
    await Promise.resolve();
    return {
      status: 200,
      body: {
        sync_at: '2026-05-17T14:11:53.695Z',
        changes: {
          created: [
            {
              id: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
              title: 'string',
              description: 'string',
              type: 'one_time',
              timeTriggerAt: '2026-05-17T14:11:53.695Z',
              geoTriggerLatitude: 0,
              geoTriggerLongitude: 0,
              geoTriggerRadius: 0,
              createdAt: '2026-05-17T14:11:53.695Z',
              updatedAt: '2026-05-17T14:11:53.695Z',
            },
          ],
          updated: [
            {
              id: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
              title: 'string',
              description: 'string',
              type: 'one_time',
              completed: true,
              timeTriggerAt: '2026-05-17T14:11:53.695Z',
              geoTriggerLatitude: 0,
              geoTriggerLongitude: 0,
              geoTriggerRadius: 0,
              updatedAt: '2026-05-17T14:11:53.695Z',
            },
          ],
          deleted: [
            {
              id: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
            },
          ],
        },
      },
    };
  },
});
