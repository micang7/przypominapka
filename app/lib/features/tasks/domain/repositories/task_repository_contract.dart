import '../../domain/entities/task.dart';

abstract class ITaskRepository {
  Stream<List<Task>> watchTasks();
  Future<void> syncTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> toggleTaskCompletion(String id);
  Future<void> reinitializeTriggers();
}
