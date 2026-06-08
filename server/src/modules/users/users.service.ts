import { db } from '../../db/client.js';
import { users } from '../../db/schema.js';
import { eq } from 'drizzle-orm';
import type { UserFindOneResDtoType } from '../../api/dtos/users/userFindOne.res.dto.js';
import { appLogger } from '../../config/logger.js';

class UsersService {
  async findOne(userId: number): Promise<UserFindOneResDtoType> {
    appLogger.debug({ userId }, 'Fetching user data');

    const user = await db.query.users.findFirst({
      where: eq(users.id, userId),
    });

    return {
      id: user!.id,
      login: user!.login,
      createdAt: user!.createdAt.toISOString(),
      updatedAt: user!.updatedAt.toISOString(),
    };
  }

  async delete(userId: number): Promise<void> {
    appLogger.debug({ userId }, 'User account deletion initiated');

    await db.delete(users).where(eq(users.id, userId));

    appLogger.info({ userId }, 'User account deleted successfully');
  }
}

export const usersService = new UsersService();
