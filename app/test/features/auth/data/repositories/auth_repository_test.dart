import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:app/core/services/device_service.dart';
import 'package:app/core/api/models/auth_models.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockAuthNamespace extends Mock implements AuthNamespace {}
class MockUsersNamespace extends Mock implements UsersNamespace {}
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}
class MockTaskLocalDatasource extends Mock implements ITaskLocalDatasource {}
class MockDeviceService extends Mock implements DeviceService {}
class MockTaskRepository extends Mock implements TaskRepositoryImpl {}

// Fallback values
class FakeLoginRequest extends Fake implements LoginRequest {}
class FakeRegisterRequest extends Fake implements RegisterRequest {}
class FakeChangePasswordRequest extends Fake implements ChangePasswordRequest {}

void initFallbackValues() {
  registerFallbackValue(FakeLoginRequest());
  registerFallbackValue(FakeRegisterRequest());
  registerFallbackValue(FakeChangePasswordRequest());
}

void main() {
  setUpAll(() {
    initFallbackValues();
  });

  late AuthRepository repository;
  late MockApiClient mockApiClient;
  late MockAuthNamespace mockAuthNamespace;
  late MockUsersNamespace mockUsersNamespace;
  late MockAuthLocalDatasource mockAuthLocalDatasource;
  late MockTaskLocalDatasource mockTaskLocalDatasource;
  late MockDeviceService mockDeviceService;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockApiClient = MockApiClient();
    mockAuthNamespace = MockAuthNamespace();
    mockUsersNamespace = MockUsersNamespace();
    mockAuthLocalDatasource = MockAuthLocalDatasource();
    mockTaskLocalDatasource = MockTaskLocalDatasource();
    mockDeviceService = MockDeviceService();
    mockTaskRepository = MockTaskRepository();

    when(() => mockApiClient.auth).thenReturn(mockAuthNamespace);
    when(() => mockApiClient.users).thenReturn(mockUsersNamespace);
    when(() => mockApiClient.setToken(any())).thenReturn(null);
    when(() => mockApiClient.clearToken()).thenReturn(null);

    repository = AuthRepository(
      mockApiClient,
      mockAuthLocalDatasource,
      mockTaskLocalDatasource,
      mockDeviceService,
      mockTaskRepository,
    );
  });

  group('AuthRepository', () {
    test('login with valid credentials should return AuthResponse, save tokens and clear tasks', () async {
      final now = DateTime.now();
      final response = AuthResponse(
        user: UserDto(id: 1, login: 'user1', createdAt: now, updatedAt: now),
        accessToken: 'access',
        refreshToken: 'refresh',
        accessTokenExpiresAt: now.add(const Duration(hours: 1)),
        refreshTokenExpiresAt: now.add(const Duration(days: 30)),
      );

      when(() => mockDeviceService.getDeviceId()).thenAnswer((_) async => 'device1');
      when(() => mockAuthNamespace.login(any())).thenAnswer((_) async => response);
      when(() => mockAuthLocalDatasource.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken')))
          .thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});
      when(() => mockTaskRepository.syncTasks()).thenAnswer((_) async {});

      final result = await repository.login('user1', 'pass123');

      expect(result.accessToken, 'access');
      verify(() => mockAuthNamespace.login(any())).called(1);
      verify(() => mockAuthLocalDatasource.saveTokens(accessToken: 'access', refreshToken: 'refresh')).called(1);
      verify(() => mockApiClient.setToken('access')).called(1);
      verify(() => mockTaskLocalDatasource.deleteAllTasks()).called(1);
      verify(() => mockTaskRepository.syncTasks()).called(1);
    });

    test('login with test credentials should use mock response', () async {
      when(() => mockAuthLocalDatasource.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken')))
          .thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});

      final result = await repository.login('test', 'test123');

      expect(result.accessToken, 'mock_access_token');
      verifyNever(() => mockAuthNamespace.login(any()));
      verify(() => mockAuthLocalDatasource.saveTokens(accessToken: 'mock_access_token', refreshToken: 'mock_refresh_token')).called(1);
    });

    test('register should call api, save tokens and sync', () async {
       final now = DateTime.now();
      final response = AuthResponse(
        user: UserDto(id: 1, login: 'user1', createdAt: now, updatedAt: now),
        accessToken: 'access_reg',
        refreshToken: 'refresh_reg',
        accessTokenExpiresAt: now.add(const Duration(hours: 1)),
        refreshTokenExpiresAt: now.add(const Duration(days: 30)),
      );

      when(() => mockDeviceService.getDeviceId()).thenAnswer((_) async => 'device1');
      when(() => mockAuthNamespace.register(any())).thenAnswer((_) async => response);
      when(() => mockAuthLocalDatasource.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken')))
          .thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});
      when(() => mockTaskRepository.syncTasks()).thenAnswer((_) async {});

      final result = await repository.register('user1', 'pass123', 'pass123');

      expect(result.accessToken, 'access_reg');
      verify(() => mockAuthNamespace.register(any())).called(1);
    });

    test('logout should clear everything', () async {
      when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => 'refresh_token');
      when(() => mockAuthNamespace.logout(any())).thenAnswer((_) async {});
      when(() => mockAuthLocalDatasource.clearAll()).thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockAuthNamespace.logout('refresh_token')).called(1);
      verify(() => mockAuthLocalDatasource.clearAll()).called(1);
      verify(() => mockApiClient.clearToken()).called(1);
      verify(() => mockTaskLocalDatasource.deleteAllTasks()).called(1);
    });

    test('logout should clear everything even if api call fails', () async {
      when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => 'refresh_token');
      when(() => mockAuthNamespace.logout(any())).thenThrow(Exception('API error'));
      when(() => mockAuthLocalDatasource.clearAll()).thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockAuthNamespace.logout('refresh_token')).called(1);
      verify(() => mockAuthLocalDatasource.clearAll()).called(1);
      verify(() => mockApiClient.clearToken()).called(1);
      verify(() => mockTaskLocalDatasource.deleteAllTasks()).called(1);
    });

    test('logout should not call api if no refresh token', () async {
      when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => null);
      when(() => mockAuthLocalDatasource.clearAll()).thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});

      await repository.logout();

      verifyNever(() => mockAuthNamespace.logout(any()));
      verify(() => mockAuthLocalDatasource.clearAll()).called(1);
    });

    test('login should handle sync error gracefully', () async {
      final now = DateTime.now();
      final response = AuthResponse(
        user: UserDto(id: 1, login: 'u', createdAt: now, updatedAt: now),
        accessToken: 'acc',
        refreshToken: 'ref',
        accessTokenExpiresAt: now.add(const Duration(hours: 1)),
        refreshTokenExpiresAt: now.add(const Duration(days: 30)),
      );

      when(() => mockDeviceService.getDeviceId()).thenAnswer((_) async => 'd1');
      when(() => mockAuthNamespace.login(any())).thenAnswer((_) async => response);
      when(() => mockAuthLocalDatasource.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken')))
          .thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});
      when(() => mockTaskRepository.syncTasks()).thenThrow(Exception('Sync error'));

      final result = await repository.login('u', 'p');

      expect(result.accessToken, 'acc');
      verify(() => mockTaskRepository.syncTasks()).called(1);
    });

    test('register should handle sync error gracefully', () async {
      final now = DateTime.now();
      final response = AuthResponse(
        user: UserDto(id: 1, login: 'u', createdAt: now, updatedAt: now),
        accessToken: 'acc',
        refreshToken: 'ref',
        accessTokenExpiresAt: now.add(const Duration(hours: 1)),
        refreshTokenExpiresAt: now.add(const Duration(days: 30)),
      );

      when(() => mockDeviceService.getDeviceId()).thenAnswer((_) async => 'd1');
      when(() => mockAuthNamespace.register(any())).thenAnswer((_) async => response);
      when(() => mockAuthLocalDatasource.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken')))
          .thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});
      when(() => mockTaskRepository.syncTasks()).thenThrow(Exception('Sync error'));

      final result = await repository.register('u', 'p', 'p');

      expect(result.accessToken, 'acc');
      verify(() => mockTaskRepository.syncTasks()).called(1);
    });

    group('changePassword', () {
      test('should call api when token exists', () async {
        when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => 'ref');
        when(() => mockAuthNamespace.changePassword(any(), any())).thenAnswer((_) async {});

        await repository.changePassword('old', 'new');

        verify(() => mockAuthNamespace.changePassword(any(), 'ref')).called(1);
      });

      test('should throw if no refresh token', () async {
        when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => null);

        expect(() => repository.changePassword('o', 'n'), throwsException);
      });
    });

    group('tryRefresh', () {
      test('should return true and save tokens on success', () async {
        when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => 'ref');
        final response = AuthRefreshResponse(
          accessToken: 'new_acc',
          refreshToken: 'new_ref',
          accessTokenExpiresAt: DateTime.now(),
          refreshTokenExpiresAt: DateTime.now(),
        );
        when(() => mockAuthNamespace.refresh(any())).thenAnswer((_) async => response);
        when(() => mockAuthLocalDatasource.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken')))
            .thenAnswer((_) async {});

        final result = await repository.tryRefresh();

        expect(result, isTrue);
        verify(() => mockAuthLocalDatasource.saveTokens(accessToken: 'new_acc', refreshToken: 'new_ref')).called(1);
        verify(() => mockApiClient.setToken('new_acc')).called(1);
      });

      test('should return false on network error without logging out', () async {
        when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => 'ref');
        when(() => mockAuthNamespace.refresh(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        final result = await repository.tryRefresh();

        expect(result, isFalse);
        verifyNever(() => mockAuthLocalDatasource.clearAll());
      });

      test('should logout on other Dio errors', () async {
        when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => 'ref');
        when(() => mockAuthNamespace.refresh(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
          ),
        );
        when(() => mockAuthLocalDatasource.clearAll()).thenAnswer((_) async {});
        when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});

        final result = await repository.tryRefresh();

        expect(result, isFalse);
        verify(() => mockAuthLocalDatasource.clearAll()).called(1);
      });

      test('should logout on non-Dio errors', () async {
        when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => 'ref');
        when(() => mockAuthNamespace.refresh(any())).thenThrow(Exception('Fatal error'));
        when(() => mockAuthLocalDatasource.clearAll()).thenAnswer((_) async {});
        when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});

        final result = await repository.tryRefresh();

        expect(result, isFalse);
        verify(() => mockAuthLocalDatasource.clearAll()).called(1);
      });

      test('should return false if no refresh token', () async {
        when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => null);
        final result = await repository.tryRefresh();
        expect(result, isFalse);
      });

      test('should return true for mock refresh token', () async {
        when(() => mockAuthLocalDatasource.getRefreshToken()).thenAnswer((_) async => 'mock_refresh_token');
        final result = await repository.tryRefresh();
        expect(result, isTrue);
      });
    });
  });
}
