import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/database/database.dart';

part 'task_local_datasource.g.dart';

abstract class ITaskLocalDatasource {
  Stream<List<TaskEntry>> watchAllTasks();
  Future<List<TaskEntry>> getAllTasks();
  Future<TaskEntry?> getTaskById(String id);
  Future<void> upsertTask(TaskEntry task);
  Future<void> upsertTasks(List<TaskEntry> tasks);
  Future<void> deleteTask(String id);
  Future<void> hardDeleteTask(String id);
  Future<List<TaskEntry>> getPendingSyncTasks();
  Future<void> markAsSynced(String id);
  Future<void> deleteAllTasks();
}

class TaskLocalDatasource implements ITaskLocalDatasource {
  final AppDatabase db;

  TaskLocalDatasource({required this.db});

  @override
  Stream<List<TaskEntry>> watchAllTasks() {
    return (db.select(db.tasks)..where((t) => t.deletedAt.isNull())).watch();
  }

  @override
  Future<List<TaskEntry>> getAllTasks() {
    return (db.select(db.tasks)..where((t) => t.deletedAt.isNull())).get();
  }

  @override
  Future<TaskEntry?> getTaskById(String id) {
    return (db.select(db.tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<void> upsertTask(TaskEntry task) {
    return db.into(db.tasks).insertOnConflictUpdate(task);
  }

  @override
  Future<void> upsertTasks(List<TaskEntry> tasks) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.tasks, tasks);
    });
  }

  @override
  Future<void> deleteTask(String id) async {
    // Soft delete
    await (db.update(db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        deletedAt: Value(DateTime.now()),
        isPendingSync: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> hardDeleteTask(String id) async {
    await (db.delete(db.tasks)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<TaskEntry>> getPendingSyncTasks() {
    return (db.select(db.tasks)..where((t) => t.isPendingSync.equals(true))).get();
  }

  @override
  Future<void> markAsSynced(String id) {
    return (db.update(db.tasks)..where((t) => t.id.equals(id))).write(
      const TasksCompanion(isPendingSync: Value(false)),
    );
  }

  @override
  Future<void> deleteAllTasks() async {
    await db.transaction(() async {
      await db.delete(db.tasks).go();
      await db.delete(db.appMetadata).go();
    });
  }
}

@riverpod
ITaskLocalDatasource taskLocalDatasource(Ref ref) {
  return TaskLocalDatasource(db: ref.watch(appDatabaseProvider));
}
