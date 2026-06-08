import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/tasks/presentation/widgets/task_list_item.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepositoryImpl {}

void main() {
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
  });

  Widget buildPump(Task task) {
    return ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: TaskListItem(task: task),
        ),
      ),
    );
  }

  testWidgets('TaskListItem displays task title and description', (WidgetTester tester) async {
    final now = DateTime.now();
    final task = Task(
      id: '1',
      title: 'Buy Groceries',
      description: 'Milk, Eggs, Bread',
      type: TaskType.oneTime,
      completed: false,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(buildPump(task));
    await tester.pumpAndSettle();

    expect(find.text('Buy Groceries'), findsOneWidget);
    expect(find.text('Milk, Eggs, Bread'), findsOneWidget);
  });

  testWidgets('TaskListItem allows toggling completion', (WidgetTester tester) async {
    final now = DateTime.now();
    final task = Task(
      id: '1',
      title: 'Buy Groceries',
      type: TaskType.oneTime,
      completed: false,
      createdAt: now,
      updatedAt: now,
    );

    when(() => mockRepository.toggleTaskCompletion('1')).thenAnswer((_) async {});

    await tester.pumpWidget(buildPump(task));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    verify(() => mockRepository.toggleTaskCompletion('1')).called(1);
  });
}
