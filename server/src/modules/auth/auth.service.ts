import { hash } from 'argon2';
import { db } from '../../db/client.js';
import { users } from '../../db/schema.js';
import { ConflictError } from '../../utils/appErrors.js';
import type { AuthRegisterDtoType } from '../../api/dtos/auth/authRegister.dto.js';
import type { AuthRegisterResDtoType } from '../../api/dtos/auth/authRegister.res.dto.js';
import { generateTokens } from '../../utils/generateTokens.js';
import { isDbError, DbError } from '../../utils/isDbError.js';
import { appLogger } from '../../config/logger.js';
import { assertExists } from '../../utils/assertExists.js';

class AuthService {
  async register(data: AuthRegisterDtoType): Promise<AuthRegisterResDtoType> {
    appLogger.debug({ login: data.login }, 'Registration initiated');

    const passwordHash = await hash(data.password);

    try {
      const [newUser] = await db
        .insert(users)
        .values({
          login: data.login,
          passwordHash,
        })
        .returning();

      assertExists(newUser, 'Inserted user was not returned');

      const tokens = await generateTokens(newUser.id);

      appLogger.info(
        { userId: newUser.id, login: newUser.login },
        'Registration completed',
      );

      return {
        user: {
          id: newUser.id,
          login: newUser.login,
          createdAt: newUser.createdAt.toISOString(),
          updatedAt: newUser.updatedAt.toISOString(),
        },
        ...tokens,
      };
    } catch (error) {
      if (isDbError(error, DbError.UniqueViolation)) {
        appLogger.warn(
          { login: data.login },
          'Registration blocked (login already in use)',
        );
        throw new ConflictError('Login already in use', ['login']);
      }
      throw error;
    }
  }
}

export const authService = new AuthService();
