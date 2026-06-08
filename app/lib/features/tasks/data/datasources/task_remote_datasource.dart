import 'package:dio/dio.dart';
import '../models/sync_dto.dart';

abstract class ITaskRemoteDatasource {
  Future<SyncResponseDto> sync(SyncRequestDto request);
}

class TaskRemoteDatasource implements ITaskRemoteDatasource {
  final Dio dio;

  TaskRemoteDatasource({required this.dio});

  @override
  Future<SyncResponseDto> sync(SyncRequestDto request) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/sync',
        data: request.toJson(),
      );

      return SyncResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception('Połączenie przekroczyło czas oczekiwania');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Błąd serwera';
        return Exception('Błąd: $statusCode - $message');
      default:
        return Exception('Błąd sieci: ${e.message}');
    }
  }
}
