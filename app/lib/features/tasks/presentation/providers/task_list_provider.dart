import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';

part 'task_list_provider.g.dart';

@riverpod
class TaskSearchQuery extends _$TaskSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

// Provider do refreshu listy tasków (używamy po dodaniu zadania)
@riverpod
Future<void> refreshTaskList(Ref ref) async {
  // Invalidate stream aby wymusić reload
  ref.invalidate(allTasksProvider);
}

@riverpod
Stream<List<Task>> allTasks(Ref ref) {
  final repository = ref.watch(taskRepositoryProvider);
  
  return repository.watchTasks();
}

@riverpod
List<Task> filteredTasks(Ref ref) {
  final allTasksAsync = ref.watch(allTasksProvider);
  final searchQuery = ref.watch(taskSearchQueryProvider).toLowerCase();

  return allTasksAsync.maybeWhen(
    data: (tasks) {
      if (searchQuery.isEmpty) return tasks;
      return tasks.where((task) {
        return task.title.toLowerCase().contains(searchQuery) ||
            (task.description?.toLowerCase().contains(searchQuery) ?? false);
      }).toList();
    },
    orElse: () => [],
  );
}

@riverpod
List<Task> timeTasks(Ref ref) {
  final filtered = ref.watch(filteredTasksProvider);
  return filtered.where((t) => t.isTimeBased && !t.completed).toList();
}

@riverpod
List<Task> geoTasks(Ref ref) {
  final filtered = ref.watch(filteredTasksProvider);
  return filtered.where((t) => t.isGeoBased && !t.completed).toList();
}

@riverpod
List<Task> completedTasks(Ref ref) {
  final filtered = ref.watch(filteredTasksProvider);
  return filtered.where((t) => t.completed).toList();
}
