import { and, eq } from 'drizzle-orm';
import type { SessionsUpdateFcmTokenDtoType } from '../../api/dtos/sessions/sessionsUpdateFcmToken.dto.js';
import { appLogger } from '../../config/logger.js';
import { db } from '../../db/client.js';
import { sessions } from '../../db/schema.js';
import { UnauthorizedError } from '../../utils/appErrors.js';

class SessionsService {
  async updateFcmToken(
    userId: number,
    data: SessionsUpdateFcmTokenDtoType,
  ): Promise<void> {
    appLogger.debug({ userId }, 'FCM token update initiated');

    const result = await db
      .update(sessions)
      .set({
        fcmToken: data.fcmToken,
        updatedAt: new Date(),
      })
      .where(
        and(eq(sessions.userId, userId), eq(sessions.deviceId, data.deviceId)),
      )
      .returning({ id: sessions.id });

    if (result.length === 0) {
      appLogger.warn(
        { userId },
        'FCM token update blocked (no matching session)',
      );
      throw new UnauthorizedError('No active session for the device');
    }

    appLogger.info(
      { userId, sessionId: result[0]!.id },
      'FCM token updated successfully',
    );
  }
}

export const sessionsService = new SessionsService();
