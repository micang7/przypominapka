import { initContract } from '@ts-rest/core';
import { AuthRegisterResDto } from './dtos/auth/authRegister.res.dto.js';
import { ValidationErrorResDto } from './dtos/errors/validationError.res.dto.js';
import { ErrorResDto } from './dtos/errors/error.res.dto.js';
import { AuthRegisterDto } from './dtos/auth/authRegister.dto.js';
import { AuthLoginResDto } from './dtos/auth/authLogin.res.dto.js';
import { AuthLoginDto } from './dtos/auth/authLogin.dto.js';
import { AuthRefreshResDto } from './dtos/auth/authRefresh.res.dto.js';
import { UserFindOneResDto } from './dtos/users/userFindOne.res.dto.js';
import { SyncResDto } from './dtos/sync/sync.res.dto.js';
import { SyncDto } from './dtos/sync/sync.dto.js';
import z from 'zod';
import { AuthChangePasswordDto } from './dtos/auth/authChangePassword.dto.js';
import { SessionsUpdateFcmTokenDto } from './dtos/sessions/sessionsUpdateFcmToken.dto.js';

const c = initContract();

const globalResponses = {
  429: ErrorResDto,
  500: ErrorResDto,
};

export const apiContract = c.router(
  {
    auth: {
      register: {
        method: 'POST',
        path: '/auth/register',
        responses: {
          201: AuthRegisterResDto,
          400: ValidationErrorResDto,
          409: ErrorResDto,
          ...globalResponses,
        },
        body: AuthRegisterDto,
        summary: 'Rejestracja nowego użytkownika',
      },
      login: {
        method: 'POST',
        path: '/auth/login',
        responses: {
          200: AuthLoginResDto,
          400: ValidationErrorResDto,
          401: ErrorResDto,
          ...globalResponses,
        },
        body: AuthLoginDto,
        summary: 'Logowanie do aplikacji',
      },
      logout: {
        method: 'POST',
        path: '/auth/logout',
        metadata: { security: [{ bearerAuth: [] }] },
        responses: {
          204: c.noBody(),
          400: ValidationErrorResDto,
          401: ErrorResDto,
          ...globalResponses,
        },
        body: c.noBody(),
        headers: z.object({ 'x-refresh-token': z.string().min(1) }),
        summary: 'Wylogowanie i unieważnienie sesji',
      },
      refresh: {
        method: 'POST',
        path: '/auth/refresh',
        responses: {
          200: AuthRefreshResDto,
          400: ValidationErrorResDto,
          401: ErrorResDto,
          ...globalResponses,
        },
        body: c.noBody(),
        headers: z.object({ 'x-refresh-token': z.string().min(1) }),
        summary: 'Odświeżenie tokenów access i refresh',
      },
      changePassword: {
        method: 'POST',
        path: '/auth/change-password',
        metadata: { security: [{ bearerAuth: [] }] },
        responses: {
          204: c.noBody(),
          400: ValidationErrorResDto,
          401: ErrorResDto,
          ...globalResponses,
        },
        body: AuthChangePasswordDto,
        headers: z.object({ 'x-refresh-token': z.string().min(1) }),
        summary: 'Zmiana hasła użytkownika',
      },
    },
    users: {
      getMe: {
        method: 'GET',
        path: '/users/me',
        metadata: { security: [{ bearerAuth: [] }] },
        responses: {
          200: UserFindOneResDto,
          401: ErrorResDto,
          ...globalResponses,
        },
        summary: 'Pobranie profilu aktualnie zalogowanego użytkownika',
      },
      deleteMe: {
        method: 'DELETE',
        path: '/users/me',
        metadata: { security: [{ bearerAuth: [] }] },
        responses: {
          204: c.noBody(),
          401: ErrorResDto,
          ...globalResponses,
        },
        body: c.noBody(),
        summary: 'Usunięcie konta użytkownika',
      },
    },
    sync: {
      sync: {
        method: 'POST',
        path: '/sync',
        metadata: { security: [{ bearerAuth: [] }] },
        responses: {
          200: SyncResDto,
          400: ValidationErrorResDto,
          401: ErrorResDto,
          ...globalResponses,
        },
        body: SyncDto,
        summary: 'Dwukierunkowa synchronizacja zadań',
      },
    },
    sessions: {
      updateFcmToken: {
        method: 'PATCH',
        path: '/sessions/fcm-token',
        metadata: { security: [{ bearerAuth: [] }] },
        responses: {
          204: c.noBody(),
          400: ValidationErrorResDto,
          401: ErrorResDto,
          ...globalResponses,
        },
        body: SessionsUpdateFcmTokenDto,
        summary: 'Aktualizacja tokenu FCM aktualnego urządzenia',
      },
    },
  },
  {
    pathPrefix: '/api/v1',
    strictStatusCodes: true,
  },
);
