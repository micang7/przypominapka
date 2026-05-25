import '../entities/auth_response.dart';

abstract class IAuthRepository {
  /// Register new user
  Future<AuthResponse> register({
    required String login,
    required String password,
    required String confirmPassword,
  });

  /// Login user
  Future<AuthResponse> login({
    required String login,
    required String password,
  });

  /// Logout user
  Future<void> logout();

  /// Refresh tokens
  Future<AuthResponse> refreshToken({
    required String refreshToken,
  });

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get stored access token
  Future<String?> getAccessToken();

  /// Get stored refresh token
  Future<String?> getRefreshToken();
}
