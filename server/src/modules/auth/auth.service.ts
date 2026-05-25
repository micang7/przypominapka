import { hash, verify } from 'argon2';
import { db } from '../../db/client.js';
import { sessions, users } from '../../db/schema.js';
import { ConflictError, UnauthorizedError } from '../../utils/appErrors.js';
import type { AuthRegisterDtoType } from '../../api/dtos/auth/authRegister.dto.js';
import type { AuthRegisterResDtoType } from '../../api/dtos/auth/authRegister.res.dto.js';
import { generateTokens } from '../../utils/generateTokens.js';
import { isDbError, DbError } from '../../utils/isDbError.js';
import { appLogger } from '../../config/logger.js';
import { assertExists } from '../../utils/assertExists.js';
import type { AuthLoginDtoType } from '../../api/dtos/auth/authLogin.dto.js';
import type { AuthLoginResDtoType } from '../../api/dtos/auth/authLogin.res.dto.js';
import { eq } from 'drizzle-orm';

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

  async login(data: AuthLoginDtoType): Promise<AuthLoginResDtoType> {
    appLogger.debug({ login: data.login }, 'Login initiated');

    const user = await db.query.users.findFirst({
      where: eq(users.login, data.login),
    });
    if (!user) {
      throw new UnauthorizedError('Invalid login or password');
    }

    const isPasswordValid = await verify(user.passwordHash, data.password);
    if (!isPasswordValid) {
      throw new UnauthorizedError('Invalid login or password');
    }

    const tokens = await generateTokens(user.id);

    appLogger.info({ userId: user.id, login: user.login }, 'Login completed');

    return {
      user: {
        id: user.id,
        login: user.login,
        createdAt: user.createdAt.toISOString(),
        updatedAt: user.updatedAt.toISOString(),
      },
      ...tokens,
    };
  }

  async logout(userId: number, refreshToken: string): Promise<void> {
    appLogger.debug({ userId }, 'Logout initiated');

    const userSessions = await db
      .select()
      .from(sessions)
      .where(eq(sessions.userId, userId));

    appLogger.debug(
      { userId, sessions: userSessions.length },
      'User sessions found',
    );

    let sessionIdToDelete = null;

    for (const session of userSessions) {
      const isMatch = await verify(session.tokenHash, refreshToken);
      if (isMatch) {
        sessionIdToDelete = session.id;
        break;
      }
    }

    appLogger.debug(
      { userId, sessionId: sessionIdToDelete },
      'Matching session found',
    );

    if (sessionIdToDelete) {
      await db.delete(sessions).where(eq(sessions.id, sessionIdToDelete));

      appLogger.info(
        { userId, sessionId: sessionIdToDelete },
        'User current session invalidated',
      );
    } else {
      appLogger.warn({ userId }, 'No matching session was found');
    }
  }
}

export const authService = new AuthService();
