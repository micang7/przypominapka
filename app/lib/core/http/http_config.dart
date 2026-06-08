class HttpConfig {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1'; // Default for Android Emulator
  
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
