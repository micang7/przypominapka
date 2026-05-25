import { db } from '../../db/client.js';
import { users } from '../../db/schema.js';
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
      appLogger.warn({ userId }, 'User not found');
      throw new NotFoundError('User not found');
    }

    return {
      id: user.id,
      login: user.login,
      createdAt: user.createdAt.toISOString(),
      updatedAt: user.updatedAt.toISOString(),
    };
  }
}

export const usersService = new UsersService();
