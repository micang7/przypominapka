import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/http/http_config.dart';

void main() {
  group('HttpConfig', () {
    test('has valid baseUrl', () {
      expect(HttpConfig.baseUrl, isNotEmpty);
      expect(HttpConfig.baseUrl.startsWith('http'), isTrue);
    });

    test('has valid timeouts', () {
      expect(HttpConfig.connectionTimeout.inSeconds, greaterThan(0));
      expect(HttpConfig.receiveTimeout.inSeconds, greaterThan(0));
    });
  });
}
