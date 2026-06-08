import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/models/auth_models.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:app/core/services/device_service.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final AuthLocalDatasource _localDatasource;
  final ITaskLocalDatasource _taskLocalDatasource;
  final DeviceService _deviceService;
  final Ref _ref;

  AuthRepository(this._apiClient, this._localDatasource, this._taskLocalDatasource, this._deviceService, this._ref);

  Future<AuthResponse> login(String login, String password) async {
    if (login == 'test' && password == 'test123') {
      final now = DateTime.now();
      final mockResponse = AuthResponse(
        user: UserDto(
          id: 0,
          login: login,
          createdAt: now,
          updatedAt: now,
        ),
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        accessTokenExpiresAt: now.add(const Duration(hours: 1)),
        refreshTokenExpiresAt: now.add(const Duration(days: 30)),
      );

      await _localDatasource.saveTokens(
        accessToken: mockResponse.accessToken,
        refreshToken: mockResponse.refreshToken,
      );
      
      _apiClient.setToken(mockResponse.accessToken);
      await _taskLocalDatasource.deleteAllTasks();
      return mockResponse;
    }

    final response = await _apiClient.auth.login(
      LoginRequest(login: login, password: password, deviceId: await _deviceService.getDeviceId()),
    );
    
    await _localDatasource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    
    _apiClient.setToken(response.accessToken);
    await _taskLocalDatasource.deleteAllTasks();

    try {
      await _ref.read(taskRepositoryProvider).syncTasks();
    } catch (_) {}

    return response;
  }

  Future<AuthResponse> register(String login, String password, String confirmPassword) async {
    final response = await _apiClient.auth.register(
      RegisterRequest(
        login: login, 
        password: password, 
        confirmPassword: confirmPassword, 
        deviceId: await _deviceService.getDeviceId(),
      ),
    );
    
    await _localDatasource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    
    _apiClient.setToken(response.accessToken);
    await _taskLocalDatasource.deleteAllTasks();

    try {
      await _ref.read(taskRepositoryProvider).syncTasks();
    } catch (_) {}

    return response;
  }

  Future<void> logout() async {
    final refreshToken = await _localDatasource.getRefreshToken();
    if (refreshToken != null && !refreshToken.startsWith('mock')) {
      try {
        await _apiClient.auth.logout(refreshToken);
      } catch (_) {}
    }
    await _localDatasource.clearAll();
    _apiClient.clearToken();
    await _taskLocalDatasource.deleteAllTasks();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final refreshToken = await _localDatasource.getRefreshToken();
    if (refreshToken == null) throw Exception('Brak sesji (brak refresh token)');

    await _apiClient.auth.changePassword(
      ChangePasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newConfirmPassword: newPassword,
      ),
      refreshToken,
    );
  }

  Future<void> deleteAccount() async {
    await _apiClient.users.deleteMe();
    await _localDatasource.clearAll();
    _apiClient.clearToken();
    await _taskLocalDatasource.deleteAllTasks();
  }

  Future<bool> tryAutoLogin() async {
    final accessToken = await _localDatasource.getAccessToken();
    if (accessToken != null) {
      _apiClient.setToken(accessToken);
      return true; // Wchodzimy do aplikacji bez sprawdzania serwera
    }
    return false;
  }

  Future<bool> tryRefresh() async {
    final refreshToken = await _localDatasource.getRefreshToken();
    if (refreshToken != null) {
      if (refreshToken == 'mock_refresh_token') return true;
      
      try {
        final response = await _apiClient.auth.refresh(refreshToken);
        await _localDatasource.saveTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );
        _apiClient.setToken(response.accessToken);
        return true;
      } on DioException catch (e) {
            // Nie wylogowuj przy błędach sieciowych
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.unknown) {
          return false;
        }
        await logout();
      } catch (e) {
        await logout();
      }
    }
    return false;
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(authLocalDatasourceProvider),
    ref.watch(taskLocalDatasourceProvider),
    ref.watch(deviceServiceProvider),
    ref,
  );
}
