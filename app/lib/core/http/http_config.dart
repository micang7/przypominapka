/// HTTP Configuration
class HttpConfig {
  // TODO: zmienić na real URL w production
  static const String baseUrl = 'http://localhost:3000';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
