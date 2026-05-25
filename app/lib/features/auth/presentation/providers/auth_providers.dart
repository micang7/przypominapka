import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/http/http_client_provider.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository_contract.dart';

// Local datasource provider
final authLocalDatasourceProvider = Provider<IAuthLocalDatasource>((ref) {
  return AuthLocalDatasource(
    secureStorage: const FlutterSecureStorage(),
  );
});

// Remote datasource provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  return AuthRemoteDatasource(dio: httpClient.dio);
});

// Repository provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final remote = ref.watch(authRemoteDatasourceProvider);
  final local = ref.watch(authLocalDatasourceProvider);

  return AuthRepository(
    remoteDatasource: remote,
    localDatasource: local,
  );
});
