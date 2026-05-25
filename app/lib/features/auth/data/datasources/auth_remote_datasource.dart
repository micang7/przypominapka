import 'package:dio/dio.dart';
import '../models/auth_response_dto.dart';
import '../models/login_request_dto.dart';
import '../models/register_request_dto.dart';

abstract class IAuthRemoteDatasource {
  Future<AuthResponseDto> register(RegisterRequestDto request);
  Future<AuthResponseDto> login(LoginRequestDto request);
  Future<void> logout();
  Future<AuthResponseDto> refresh();
}

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource({required this.dio});

  @override
  Future<AuthResponseDto> register(RegisterRequestDto request) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: request.toJson(),
      );

      return AuthResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<AuthResponseDto> login(LoginRequestDto request) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      return AuthResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<AuthResponseDto> refresh() async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
      );

      return AuthResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error';
        return Exception('Error: $statusCode - $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
