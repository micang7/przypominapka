import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/task_repository_contract.dart';
import '../../data/repositories/task_repository_impl.dart' as repo;

part 'tasks_providers.g.dart';

@riverpod
ITaskRepository taskRepository(Ref ref) {
  return ref.watch(repo.taskRepositoryProvider);
}
