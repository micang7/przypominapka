import { db } from '../../db/client.js';
import { sessions, users } from '../../db/schema.js';
import { eq } from 'drizzle-orm';
import { NotFoundError } from '../../utils/appErrors.js';
import type { UserFindOneResDtoType } from '../../api/dtos/users/userFindOne.res.dto.js';
import { appLogger } from '../../config/logger.js';

class UsersService {
  async findOne(userId: number): Promise<UserFindOneResDtoType> {
    appLogger.debug({ userId }, 'Fetching user data');

    const user = await db.query.users.findFirst({
      where: eq(users.id, userId),
    });

    if (!user) {
      appLogger.warn({ userId }, 'User not found during fetching attempt');
      throw new NotFoundError('User not found');
    }

    return {
      id: user.id,
      login: user.login,
      createdAt: user.createdAt.toISOString(),
      updatedAt: user.updatedAt.toISOString(),
    };
  }

  async delete(userId: number): Promise<void> {
    appLogger.debug({ userId }, 'User account deletion initiated');

    const user = await db.query.users.findFirst({
      where: eq(users.id, userId),
    });

    if (!user) {
      appLogger.warn({ userId }, 'User not found during deletion attempt');
      throw new NotFoundError('User not found');
    }

    await db.transaction(async (tx) => {
      await tx.delete(sessions).where(eq(sessions.userId, userId));
      await tx.delete(users).where(eq(users.id, userId));
    });

    appLogger.info(
      { userId },
      'User account and all sessions deleted successfully',
    );
  }
}

export const usersService = new UsersService();
