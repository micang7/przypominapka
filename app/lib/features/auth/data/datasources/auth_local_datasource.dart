import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class IAuthLocalDatasource {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> deleteAccessToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();
  Future<void> clearAllTokens();
}

class AuthLocalDatasource implements IAuthLocalDatasource {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _secureStorage;

  AuthLocalDatasource({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> saveAccessToken(String token) =>
      _secureStorage.write(key: _accessTokenKey, value: token);

  @override
  Future<String?> getAccessToken() =>
      _secureStorage.read(key: _accessTokenKey);

  @override
  Future<void> deleteAccessToken() =>
      _secureStorage.delete(key: _accessTokenKey);

  @override
  Future<void> saveRefreshToken(String token) =>
      _secureStorage.write(key: _refreshTokenKey, value: token);

  @override
  Future<String?> getRefreshToken() =>
      _secureStorage.read(key: _refreshTokenKey);

  @override
  Future<void> deleteRefreshToken() =>
      _secureStorage.delete(key: _refreshTokenKey);

  @override
  Future<void> clearAllTokens() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }
}
