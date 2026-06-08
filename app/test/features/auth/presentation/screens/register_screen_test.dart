import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/presentation/screens/register_screen.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/core/api/models/auth_models.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    when(() => mockRepository.tryAutoLogin()).thenAnswer((_) async => false);
  });

  testWidgets('RegisterScreen shows form fields and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Verify UI elements
    expect(find.text('Zarejestruj się'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3)); // Login, Password, Confirm Password
    expect(find.byType(FilledButton), findsOneWidget); // Register button
    expect(find.byType(TextButton), findsOneWidget); // Login button (back)
  });

  testWidgets('RegisterScreen validates empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Tap register button without entering data
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    // Verify error messages
    expect(find.text('Podaj login'), findsOneWidget);
    expect(find.text('Podaj hasło'), findsWidgets); // Both password fields will show this or something similar
  });
}
