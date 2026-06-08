import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late AuthLocalDatasource datasource;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    datasource = AuthLocalDatasource(mockStorage);
  });

  test('saveTokens should write tokens to secure storage', () async {
    when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    await datasource.saveTokens(accessToken: 'at', refreshToken: 'rt');

    verify(() => mockStorage.write(key: 'access_token', value: 'at')).called(1);
    verify(() => mockStorage.write(key: 'refresh_token', value: 'rt')).called(1);
  });

  test('getAccessToken should read from secure storage', () async {
    when(() => mockStorage.read(key: 'access_token')).thenAnswer((_) async => 'token');

    final result = await datasource.getAccessToken();

    expect(result, 'token');
    verify(() => mockStorage.read(key: 'access_token')).called(1);
  });
}
