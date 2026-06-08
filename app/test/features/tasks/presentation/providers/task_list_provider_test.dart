import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/tasks/presentation/providers/task_list_provider.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepositoryImpl {}

void main() {
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('taskSearchQueryProvider should start empty and update', () {
    final container = createContainer();
    
    expect(container.read(taskSearchQueryProvider), '');
    
    container.read(taskSearchQueryProvider.notifier).setQuery('abc');
    expect(container.read(taskSearchQueryProvider), 'abc');
  });

  test('allTasksProvider should stream from repository', () async {
    final now = DateTime.now();
    final tasks = [
      Task(id: '1', title: 'T1', type: TaskType.oneTime, completed: false, createdAt: now, updatedAt: now)
    ];
    when(() => mockRepository.watchTasks()).thenAnswer((_) => Stream.value(tasks));

    final container = createContainer();
    container.listen(allTasksProvider, (prev, next) {}); // Keep alive
    final result = await container.read(allTasksProvider.future);
    
    expect(result.length, 1);
    expect(result.first.title, 'T1');
  });

  test('filteredTasksProvider filters by title and description', () async {
    final now = DateTime.now();
    final tasks = [
      Task(id: '1', title: 'Apple', description: 'Red fruit', type: TaskType.oneTime, completed: false, createdAt: now, updatedAt: now),
      Task(id: '2', title: 'Banana', description: 'Yellow fruit', type: TaskType.oneTime, completed: false, createdAt: now, updatedAt: now),
    ];
    
    when(() => mockRepository.watchTasks()).thenAnswer((_) => Stream.value(tasks));
    
    final container = createContainer();
    container.listen(allTasksProvider, (prev, next) {}); // Keep alive
    await container.read(allTasksProvider.future);
    
    // No query
    expect(container.read(filteredTasksProvider).length, 2);
    
    // Query title
    container.read(taskSearchQueryProvider.notifier).setQuery('app');
    expect(container.read(filteredTasksProvider).length, 1);
    expect(container.read(filteredTasksProvider).first.title, 'Apple');
    
    // Query description
    container.read(taskSearchQueryProvider.notifier).setQuery('yellow');
    expect(container.read(filteredTasksProvider).length, 1);
    expect(container.read(filteredTasksProvider).first.title, 'Banana');
  });

  test('timeTasks, geoTasks, completedTasks providers sort tasks correctly', () async {
    final now = DateTime.now();
    final tasks = [
      Task(id: '1', title: 'Time', type: TaskType.oneTime, completed: false, timeTriggerAt: now, createdAt: now, updatedAt: now),
      Task(id: '2', title: 'Geo', type: TaskType.oneTime, completed: false, geoTriggerLatitude: 50, geoTriggerLongitude: 50, geoTriggerRadius: 100, createdAt: now, updatedAt: now),
      Task(id: '3', title: 'Done', type: TaskType.oneTime, completed: true, createdAt: now, updatedAt: now),
    ];
    
    when(() => mockRepository.watchTasks()).thenAnswer((_) => Stream.value(tasks));
    
    final container = createContainer();
    container.listen(allTasksProvider, (prev, next) {}); // Keep alive
    await container.read(allTasksProvider.future);
    
    expect(container.read(timeTasksProvider).length, 1);
    expect(container.read(timeTasksProvider).first.title, 'Time');
    
    expect(container.read(geoTasksProvider).length, 1);
    expect(container.read(geoTasksProvider).first.title, 'Geo');
    
    expect(container.read(completedTasksProvider).length, 1);
    expect(container.read(completedTasksProvider).first.title, 'Done');
  });
}
