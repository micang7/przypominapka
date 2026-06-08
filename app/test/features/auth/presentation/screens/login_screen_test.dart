import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/presentation/screens/login_screen.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/core/api/models/auth_models.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    // Default stub for tryAutoLogin since AuthStateNotifier calls it on build
    when(() => mockRepository.tryAutoLogin()).thenAnswer((_) async => false);
  });

  testWidgets('LoginScreen shows form fields and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify UI elements
    expect(find.text('Zaloguj się, aby kontynuować'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Login & Password
    expect(find.byType(FilledButton), findsOneWidget); // Login button
    expect(find.byType(TextButton), findsOneWidget); // Register button
  });

  testWidgets('LoginScreen validates empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Tap login button without entering data
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    // Verify error messages
    expect(find.text('Podaj login'), findsOneWidget);
    expect(find.text('Podaj hasło'), findsOneWidget);
  });

  testWidgets('LoginScreen triggers login on valid submission', (WidgetTester tester) async {
    final now = DateTime.now();
    when(() => mockRepository.login(any(), any())).thenAnswer(
      (_) async => AuthResponse(
        user: UserDto(id: 1, login: 'test', createdAt: now, updatedAt: now),
        accessToken: 'access',
        refreshToken: 'refresh',
        accessTokenExpiresAt: now,
        refreshTokenExpiresAt: now,
      ),
    );
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Enter text
    await tester.enterText(find.byType(TextFormField).first, 'user123');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    
    // Tap login button
    await tester.tap(find.byType(FilledButton));
    await tester.pump(); // Start loading
    await tester.pumpAndSettle(); // Finish loading

    // Verify mock was called
    verify(() => mockRepository.login('user123', 'password123')).called(1);
  });
}
