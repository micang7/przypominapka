import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/models/auth_models.dart';
import 'package:app/core/api/models/task_models.dart' as api;
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockBaseOptions extends Mock implements BaseOptions {}
class MockHeaders extends Mock implements Map<String, dynamic> {}

void main() {
  late MockDio mockDio;
  late ApiClient apiClient;

  setUp(() {
    mockDio = MockDio();
    final mockOptions = MockBaseOptions();
    final mockHeaders = MockHeaders();
    
    when(() => mockDio.options).thenReturn(mockOptions);
    when(() => mockOptions.headers).thenReturn(mockHeaders);
    when(() => mockHeaders['Authorization'] = any()).thenAnswer((_) {});
    when(() => mockHeaders.remove('Authorization')).thenAnswer((_) {});

    apiClient = ApiClient(mockDio);
  });

  group('ApiClient token management', () {
    test('setToken adds authorization header', () {
      apiClient.setToken('my_token');
      verify(() => mockDio.options.headers['Authorization'] = 'Bearer my_token').called(1);
    });

    test('clearToken removes authorization header', () {
      apiClient.clearToken();
      verify(() => mockDio.options.headers.remove('Authorization')).called(1);
    });
  });

  group('AuthNamespace', () {
    test('login returns AuthResponse', () async {
      final request = const LoginRequest(login: 'u', password: 'p', deviceId: 'd');
      final responseData = {
        'user': {'id': 1, 'login': 'u', 'createdAt': '2023-01-01T00:00:00Z', 'updatedAt': '2023-01-01T00:00:00Z'},
        'accessToken': 'a',
        'refreshToken': 'r',
        'accessTokenExpiresAt': '2023-01-01T00:00:00Z',
        'refreshTokenExpiresAt': '2023-01-01T00:00:00Z',
      };
      
      when(() => mockDio.post('/auth/login', data: any(named: 'data')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), data: responseData));

      final result = await apiClient.auth.login(request);
      expect(result.accessToken, 'a');
    });

    test('register returns AuthResponse', () async {
      final request = const RegisterRequest(login: 'u', password: 'p', confirmPassword: 'p', deviceId: 'd');
      final responseData = {
        'user': {'id': 1, 'login': 'u', 'createdAt': '2023-01-01T00:00:00Z', 'updatedAt': '2023-01-01T00:00:00Z'},
        'accessToken': 'a',
        'refreshToken': 'r',
        'accessTokenExpiresAt': '2023-01-01T00:00:00Z',
        'refreshTokenExpiresAt': '2023-01-01T00:00:00Z',
      };
      
      when(() => mockDio.post('/auth/register', data: any(named: 'data')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), data: responseData));

      final result = await apiClient.auth.register(request);
      expect(result.accessToken, 'a');
    });

    test('logout calls api with refresh token header', () async {
      when(() => mockDio.post('/auth/logout', options: any(named: 'options')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: '')));

      await apiClient.auth.logout('refresh_token');
      
      final captured = verify(() => mockDio.post('/auth/logout', options: captureAny(named: 'options'))).captured.first as Options;
      expect(captured.headers?['x-refresh-token'], 'refresh_token');
    });

    test('refresh returns AuthRefreshResponse', () async {
      final responseData = {
        'accessToken': 'new_a',
        'refreshToken': 'new_r',
        'accessTokenExpiresAt': '2023-01-01T00:00:00Z',
        'refreshTokenExpiresAt': '2023-01-01T00:00:00Z',
      };
      
      when(() => mockDio.post('/auth/refresh', options: any(named: 'options')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), data: responseData));

      final result = await apiClient.auth.refresh('old_r');
      expect(result.accessToken, 'new_a');
    });

    test('changePassword calls api with headers and data', () async {
      final request = const ChangePasswordRequest(oldPassword: 'o', newPassword: 'n', newConfirmPassword: 'n');
      
      when(() => mockDio.post('/auth/change-password', data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: '')));

      await apiClient.auth.changePassword(request, 'r');
      
      verify(() => mockDio.post('/auth/change-password', data: any(named: 'data'), options: any(named: 'options'))).called(1);
    });
  });

  group('UsersNamespace', () {
    test('getMe returns UserDto', () async {
      final responseData = {'id': 1, 'login': 'u', 'createdAt': '2023-01-01T00:00:00Z', 'updatedAt': '2023-01-01T00:00:00Z'};
      
      when(() => mockDio.get('/users/me'))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), data: responseData));

      final result = await apiClient.users.getMe();
      expect(result.id, 1);
    });

    test('deleteMe calls api', () async {
      when(() => mockDio.delete('/users/me'))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: '')));

      await apiClient.users.deleteMe();
      verify(() => mockDio.delete('/users/me')).called(1);
    });
  });

  group('SyncNamespace', () {
    test('sync returns SyncResponse', () async {
      final request = api.SyncRequest(lastSyncAt: DateTime.now(), changes: const api.SyncChanges(), deviceId: '1');
      final responseData = {
        'sync_at': '2023-01-01T00:00:00Z',
        'changes': {'created': [], 'updated': [], 'deleted': []}
      };
      
      when(() => mockDio.post('/sync', data: any(named: 'data')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), data: responseData));

      final result = await apiClient.sync.sync(request);
      expect(result.syncAt, isNotNull);
    });
  });
  
  group('SessionsNamespace', () {
    test('updateFcmToken calls patch', () async {
      final request = const api.SessionsUpdateFcmTokenDto(deviceId: 'd', fcmToken: 't');
      
      when(() => mockDio.patch('/sessions/fcm-token', data: any(named: 'data')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: '')));

      await apiClient.sessions.updateFcmToken(request);
      verify(() => mockDio.patch('/sessions/fcm-token', data: any(named: 'data'))).called(1);
    });
  });
}
