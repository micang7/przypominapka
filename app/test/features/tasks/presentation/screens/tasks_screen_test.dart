import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepositoryImpl {}

void main() {
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    when(() => mockRepository.syncTasks()).thenAnswer((_) async {});
  });

  Widget buildPump(List<Task> tasks) {
    return ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(home: TasksScreen()),
    );
  }

  testWidgets('TasksScreen shows empty state when no tasks', (WidgetTester tester) async {
    when(() => mockRepository.watchTasks()).thenAnswer((_) => Stream.value([]));

    await tester.pumpWidget(buildPump([]));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // allow animations and stream

    expect(find.text('Twoje Zadania'), findsOneWidget);
    expect(find.text('Brak zadań. Dodaj coś za pomocą przycisku +'), findsOneWidget);
  });

  testWidgets('TasksScreen shows tasks categorized', (WidgetTester tester) async {
    final now = DateTime.now();
    final tasks = [
      Task(id: '1', title: 'Time Task', type: TaskType.oneTime, completed: false, timeTriggerAt: now.add(const Duration(days: 1)), createdAt: now, updatedAt: now),
      Task(id: '2', title: 'Geo Task', type: TaskType.oneTime, completed: false, geoTriggerLatitude: 50, geoTriggerLongitude: 50, geoTriggerRadius: 100, createdAt: now, updatedAt: now),
      Task(id: '3', title: 'Completed Task', type: TaskType.oneTime, completed: true, createdAt: now, updatedAt: now),
    ];

    when(() => mockRepository.watchTasks()).thenAnswer((_) => Stream.value(tasks));

    await tester.pumpWidget(buildPump(tasks));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Zadania czasowe'), findsOneWidget);
    expect(find.text('Time Task'), findsOneWidget);

    expect(find.text('Zadania regionalne'), findsOneWidget);
    expect(find.text('Geo Task'), findsOneWidget);

    expect(find.text('Wykonane'), findsOneWidget);
    expect(find.text('Completed Task'), findsOneWidget);
  });

  testWidgets('TasksScreen allows searching', (WidgetTester tester) async {
    final now = DateTime.now();
    final tasks = [
      Task(id: '1', title: 'Apple', type: TaskType.oneTime, completed: false, timeTriggerAt: now, createdAt: now, updatedAt: now),
      Task(id: '2', title: 'Banana', type: TaskType.oneTime, completed: false, timeTriggerAt: now, createdAt: now, updatedAt: now),
    ];

    when(() => mockRepository.watchTasks()).thenAnswer((_) => Stream.value(tasks));

    await tester.pumpWidget(buildPump(tasks));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'app');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
  });
}
