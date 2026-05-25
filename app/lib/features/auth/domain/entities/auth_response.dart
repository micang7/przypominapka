import 'user.dart';

class AuthResponse {
  final User user;
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAt;
  final DateTime refreshTokenExpiresAt;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthResponse &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken &&
          accessTokenExpiresAt == other.accessTokenExpiresAt &&
          refreshTokenExpiresAt == other.refreshTokenExpiresAt;

  @override
  int get hashCode =>
      user.hashCode ^
      accessToken.hashCode ^
      refreshToken.hashCode ^
      accessTokenExpiresAt.hashCode ^
      refreshTokenExpiresAt.hashCode;

  @override
  String toString() =>
      'AuthResponse(user: $user, accessToken: $accessToken, refreshToken: $refreshToken, accessTokenExpiresAt: $accessTokenExpiresAt, refreshTokenExpiresAt: $refreshTokenExpiresAt)';
}
