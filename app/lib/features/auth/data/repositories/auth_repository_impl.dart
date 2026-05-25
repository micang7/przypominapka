import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_dto.dart';
import '../models/register_request_dto.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository_contract.dart';

class AuthRepository implements IAuthRepository {
  final IAuthRemoteDatasource _remoteDatasource;
  final IAuthLocalDatasource _localDatasource;

  AuthRepository({
    required IAuthRemoteDatasource remoteDatasource,
    required IAuthLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  @override
  Future<AuthResponse> register({
    required String login,
    required String password,
    required String confirmPassword,
  }) async {
    final request = RegisterRequestDto(
      login: login,
      password: password,
      confirmPassword: confirmPassword,
    );

    final responseDto = await _remoteDatasource.register(request);
    
    // Save tokens
    await _localDatasource.saveAccessToken(responseDto.accessToken);
    await _localDatasource.saveRefreshToken(responseDto.refreshToken);

    return _mapDtoToEntity(responseDto);
  }

  @override
  Future<AuthResponse> login({
    required String login,
    required String password,
  }) async {
    final request = LoginRequestDto(login: login, password: password);

    final responseDto = await _remoteDatasource.login(request);

    // Save tokens
    await _localDatasource.saveAccessToken(responseDto.accessToken);
    await _localDatasource.saveRefreshToken(responseDto.refreshToken);

    return _mapDtoToEntity(responseDto);
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDatasource.logout();
    } finally {
      await _localDatasource.clearAllTokens();
    }
  }

  @override
  Future<AuthResponse> refreshToken({
    required String refreshToken,
  }) async {
    final responseDto = await _remoteDatasource.refresh();

    // Save new tokens
    await _localDatasource.saveAccessToken(responseDto.accessToken);
    await _localDatasource.saveRefreshToken(responseDto.refreshToken);

    return _mapDtoToEntity(responseDto);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localDatasource.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getAccessToken() => _localDatasource.getAccessToken();

  @override
  Future<String?> getRefreshToken() => _localDatasource.getRefreshToken();

  /// Map AuthResponseDto to AuthResponse (domain entity)
  AuthResponse _mapDtoToEntity(dynamic responseDto) {
    return AuthResponse(
      user: User(
        id: responseDto.user.id,
        login: responseDto.user.login,
        email: responseDto.user.email,
        createdAt: responseDto.user.createdAt,
        updatedAt: responseDto.user.updatedAt,
      ),
      accessToken: responseDto.accessToken,
      refreshToken: responseDto.refreshToken,
      accessTokenExpiresAt: responseDto.accessTokenExpiresAt,
      refreshTokenExpiresAt: responseDto.refreshTokenExpiresAt,
    );
  }
}
