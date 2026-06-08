import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:app/core/services/device_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    test('deleteAccount should call api and clear everything', () async {
      when(() => mockUsersNamespace.deleteMe()).thenAnswer((_) async {});
      when(() => mockAuthLocalDatasource.clearAll()).thenAnswer((_) async {});
      when(() => mockTaskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});

      await repository.deleteAccount();

      verify(() => mockUsersNamespace.deleteMe()).called(1);
      verify(() => mockAuthLocalDatasource.clearAll()).called(1);
      verify(() => mockTaskLocalDatasource.deleteAllTasks()).called(1);
    });
    
    test('tryAutoLogin should return true if token exists', () async {
        when(() => mockAuthLocalDatasource.getAccessToken()).thenAnswer((_) async => 'some_token');
        
        final result = await repository.tryAutoLogin();
        
        expect(result, isTrue);
        verify(() => mockApiClient.setToken('some_token')).called(1);
    });
    
    test('tryAutoLogin should return false if no token', () async {
        when(() => mockAuthLocalDatasource.getAccessToken()).thenAnswer((_) async => null);
        
        final result = await repository.tryAutoLogin();
        
        expect(result, isFalse);
        verifyNever(() => mockApiClient.setToken(any()));
    });
  });
}
