import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/models/auth_models.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final AuthLocalDatasource _localDatasource;

  AuthRepository(this._apiClient, this._localDatasource);

  Future<AuthResponse> login(String login, String password) async {
    if (login == 'test' && password == 'test123') {
      final now = DateTime.now();
      final mockResponse = AuthResponse(
        user: UserDto(
          id: 'mock-id-123',
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
      return mockResponse;
    }

    final response = await _apiClient.auth.login(
      LoginRequest(login: login, password: password),
    );
    
    await _localDatasource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    
    _apiClient.setToken(response.accessToken);
    return response;
  }

  Future<AuthResponse> register(String login, String password) async {
    final response = await _apiClient.auth.register(
      RegisterRequest(login: login, password: password),
    );
    
    await _localDatasource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    
    _apiClient.setToken(response.accessToken);
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
  }

  Future<bool> tryAutoLogin() async {
    final accessToken = await _localDatasource.getAccessToken();
    if (accessToken != null) {
      _apiClient.setToken(accessToken);
      
      // Jeśli jesteśmy na mocku, nie sprawdzamy serwera
      if (accessToken == 'mock_access_token') return true;

      try {
        await _apiClient.users.getMe();
        return true;
      } catch (e) {
        return await tryRefresh();
      }
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
  );
}
