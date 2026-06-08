import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/api/models/auth_models.dart';

void main() {
  group('AuthResponse', () {
    test('should correctly deserialize from JSON', () {
      final json = {
        'accessToken': 'access',
        'refreshToken': 'refresh',
        'accessTokenExpiresAt': '2023-01-01T12:00:00.000Z',
        'refreshTokenExpiresAt': '2023-01-01T12:00:00.000Z',
        'user': {
          'id': 1,
          'login': 'testuser',
          'createdAt': '2023-01-01T10:00:00.000Z',
          'updatedAt': '2023-01-01T10:00:00.000Z',
        }
      };

      final dto = AuthResponse.fromJson(json);

      expect(dto.accessToken, 'access');
      expect(dto.user.login, 'testuser');
    });
  });
}
