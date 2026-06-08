import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/utils/error_parser.dart';
import 'package:dio/dio.dart';

void main() {
  group('ErrorParser', () {
    test('parses DioException connection errors', () {
      final timeoutError = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
      );
      expect(ErrorParser.parse(timeoutError), 'Przekroczono czas połączenia. Sprawdź internet.');

      final connError = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );
      expect(ErrorParser.parse(connError), 'Brak połączenia z serwerem.');
    });

    test('parses DioException badResponse errors', () {
      final e401 = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: '/'), statusCode: 401),
      );
      expect(ErrorParser.parse(e401), 'Nieprawidłowy login lub hasło.');

      final e409 = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: '/'), statusCode: 409),
      );
      expect(ErrorParser.parse(e409), 'Użytkownik o takim loginie już istnieje.');
      
      final e400 = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: '/'), statusCode: 400),
      );
      expect(ErrorParser.parse(e400), 'Błędne dane. Sprawdź formularz.');
    });

    test('parses string error regarding passwords', () {
      expect(ErrorParser.parse('Invalid password'), 'Stare hasło jest nieprawidłowe.');
    });

    test('parses generic fallback', () {
      expect(ErrorParser.parse('Random error'), 'Coś poszło nie tak. Spróbuj ponownie.');
    });
  });
}
