import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/http/http_config.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'models/auth_models.dart';
import 'models/task_models.dart';

part 'api_client.g.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _auth = AuthNamespace(_dio);
    _users = UsersNamespace(_dio);
    _sync = SyncNamespace(_dio);
    _sessions = SessionsNamespace(_dio);
  }

  late final AuthNamespace _auth;
  late final UsersNamespace _users;
  late final SyncNamespace _sync;
  late final SessionsNamespace _sessions;

  AuthNamespace get auth => _auth;
  UsersNamespace get users => _users;
  SyncNamespace get sync => _sync;
  SessionsNamespace get sessions => _sessions;

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }
}

class AuthNamespace {
  final Dio _dio;
  AuthNamespace(this._dio);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _dio.post('/auth/register', data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post(
      '/auth/logout',
      options: Options(headers: {'x-refresh-token': refreshToken}),
    );
  }

  Future<AuthRefreshResponse> refresh(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      options: Options(headers: {'x-refresh-token': refreshToken}),
    );
    return AuthRefreshResponse.fromJson(response.data);
  }

  Future<void> changePassword(ChangePasswordRequest request, String refreshToken) async {
    await _dio.post(
      '/auth/change-password',
      data: request.toJson(),
      options: Options(headers: {'x-refresh-token': refreshToken}),
    );
  }
}

class UsersNamespace {
  final Dio _dio;
  UsersNamespace(this._dio);

  Future<UserDto> getMe() async {
    final response = await _dio.get('/users/me');
    return UserDto.fromJson(response.data);
  }

  Future<void> deleteMe() async {
    await _dio.delete('/users/me');
  }
}

class SyncNamespace {
  final Dio _dio;
  SyncNamespace(this._dio);

  Future<SyncResponse> sync(SyncRequest request) async {
    final response = await _dio.post('/sync', data: request.toJson());
    return SyncResponse.fromJson(response.data);
  }
}

class SessionsNamespace {
  final Dio _dio;
  SessionsNamespace(this._dio);

  Future<void> updateFcmToken(SessionsUpdateFcmTokenDto request) async {
    await _dio.patch('/sessions/fcm-token', data: request.toJson());
  }
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: HttpConfig.baseUrl,
      connectTimeout: HttpConfig.connectionTimeout,
      receiveTimeout: HttpConfig.receiveTimeout,
      contentType: 'application/json',
    ),
  );

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  final client = ApiClient(dio);

  // Załaduj token przy starcie
  ref.watch(authLocalDatasourceProvider).getAccessToken().then((token) {
    if (token != null) {
      client.setToken(token);
    }
  });

  return client;
}
