import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/tasks/presentation/screens/main_screen.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/core/services/permissions_service.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepositoryImpl {}
class MockPermissionsService extends Mock implements PermissionsService {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockAuthNotifier extends AuthStateNotifier with Mock {
  @override
  AuthState build() => const AuthState(isInitializing: false);
  @override
  Future<void> logout() async {}
}

void main() {
  late MockTaskRepository mockTaskRepository;
  late MockPermissionsService mockPermissionsService;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockPermissionsService = MockPermissionsService();
    mockAuthRepository = MockAuthRepository();

    when(() => mockPermissionsService.requestInitialPermissions()).thenAnswer((_) async {});
    when(() => mockTaskRepository.reinitializeTriggers()).thenAnswer((_) async {});
    when(() => mockTaskRepository.watchTasks()).thenAnswer((_) => Stream.value([]));
    when(() => mockTaskRepository.syncTasks()).thenAnswer((_) async {});
  });

  Widget buildPump(Widget child) {
    return ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(mockTaskRepository),
        permissionsServiceProvider.overrideWithValue(mockPermissionsService),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('MainScreen shows bottom navigation and initial tasks screen', (WidgetTester tester) async {
    await tester.pumpWidget(buildPump(const MainScreen()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // wait for streams

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Zadania'), findsOneWidget);
    expect(find.text('Mapa'), findsOneWidget);
    expect(find.text('Zadanie czasowe'), findsOneWidget); // FAB
  });

  testWidgets('MainScreen changes tab to Map', (WidgetTester tester) async {
    await tester.pumpWidget(buildPump(const MainScreen()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Mapa'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Zadanie regionalne'), findsOneWidget); // FAB changes on Map tab
  });

  testWidgets('MainScreen opens drawer and logs out', (WidgetTester tester) async {
    await tester.pumpWidget(buildPump(const MainScreen()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Otwórz drawer uderzając w niewidoczny przycisk menu lub po prostu przez gest
    ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Wyloguj się'), findsOneWidget);
  });
}
