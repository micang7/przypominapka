import 'package:dio/dio.dart';

class ErrorParser {
  static String parse(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Przekroczono czas połączenia. Sprawdź internet.';
        case DioExceptionType.connectionError:
          return 'Brak połączenia z serwerem.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) return 'Nieprawidłowy login lub hasło.';
          if (statusCode == 409) return 'Użytkownik o takim loginie już istnieje.';
          if (statusCode == 400) return 'Błędne dane. Sprawdź formularz.';
          if (statusCode == 500) return 'Błąd serwera. Spróbuj później.';
          return 'Błąd serwera ($statusCode).';
        default:
          return 'Wystąpił nieoczekiwany błąd sieciowy.';
      }
    }
    
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('invalid password') || errorStr.contains('wrong password')) {
      return 'Stare hasło jest nieprawidłowe.';
    }
    
    return 'Coś poszło nie tak. Spróbuj ponownie.';
  }
}
