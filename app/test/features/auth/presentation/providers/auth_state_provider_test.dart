import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/core/api/models/auth_models.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('AuthStateNotifier initializes and tries auto login', () async {
    when(() => mockRepository.tryAutoLogin()).thenAnswer((_) async => true);
    
    final container = createContainer();
    final sub = container.listen(authStateProvider, (prev, next) {}); // keep alive
    
    // Check initial state
    expect(container.read(authStateProvider).isInitializing, true);
    
    // Wait for init
    await Future.delayed(Duration.zero);
    
    expect(container.read(authStateProvider).isInitializing, false);
    expect(container.read(authStateProvider).isAuthenticated, true);
    sub.close();
  });

  test('AuthStateNotifier login updates state on success', () async {
    when(() => mockRepository.tryAutoLogin()).thenAnswer((_) async => false);
    when(() => mockRepository.login(any(), any())).thenAnswer((_) async => throw Exception('Wont be checked here just mocked'));
    // We actually want a success mock
    when(() => mockRepository.login('u', 'p')).thenAnswer((_) async => throw UnimplementedError('We mock below properly'));
    
    final container = createContainer();
    container.listen(authStateProvider, (prev, next) {});
    await Future.delayed(Duration.zero);

    when(() => mockRepository.login('u', 'p')).thenAnswer((_) async => AuthResponse(
      user: UserDto(id: 1, login: 'u', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      accessToken: 'a',
      refreshToken: 'r',
      accessTokenExpiresAt: DateTime.now(),
      refreshTokenExpiresAt: DateTime.now(),
    ));

    await container.read(authStateProvider.notifier).login('u', 'p');

    expect(container.read(authStateProvider).isAuthenticated, true);
    expect(container.read(authStateProvider).isLoading, false);
  });

  test('AuthStateNotifier login updates state on failure', () async {
    when(() => mockRepository.tryAutoLogin()).thenAnswer((_) async => false);
    
    final container = createContainer();
    container.listen(authStateProvider, (prev, next) {});
    await Future.delayed(Duration.zero);

    when(() => mockRepository.login('u', 'p')).thenThrow(Exception('Login failed'));

    await container.read(authStateProvider.notifier).login('u', 'p');

    expect(container.read(authStateProvider).isAuthenticated, false);
    expect(container.read(authStateProvider).error, contains('Login failed'));
  });

  test('AuthStateNotifier logout clears state', () async {
    when(() => mockRepository.tryAutoLogin()).thenAnswer((_) async => false);
    when(() => mockRepository.logout()).thenAnswer((_) async {});
    
    final container = createContainer();
    container.listen(authStateProvider, (prev, next) {});
    await Future.delayed(Duration.zero);

    await container.read(authStateProvider.notifier).logout();

    expect(container.read(authStateProvider).isAuthenticated, false);
    verify(() => mockRepository.logout()).called(1);
  });
}
