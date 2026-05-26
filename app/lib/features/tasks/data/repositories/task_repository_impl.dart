import 'dart:async';
import 'dart:developer' as dev;
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/models/task_models.dart' as api;
import 'package:app/core/database/database.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/features/tasks/domain/repositories/task_repository_contract.dart';
import 'package:app/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';

part 'task_repository_impl.g.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final ITaskLocalDatasource localDatasource;
  final ApiClient apiClient;
  final Ref ref;

  TaskRepositoryImpl({
    required this.localDatasource,
    required this.apiClient,
    required this.ref,
  });

  @override
  Stream<List<Task>> watchTasks() {
    dev.log('TaskRepository: watchTasks() started');
    return localDatasource.watchAllTasks().map((entries) {
      dev.log('TaskRepository: Stream emitted ${entries.length} tasks');
      return entries.map(_entryToEntity).toList();
    });
  }

  @override
  Future<void> syncTasks() async {
    dev.log('TaskRepository: syncTasks() started');
    try {
      final lastSyncAtStr = await _getMetadata('last_sync_at');
      final lastSyncAt = lastSyncAtStr != null 
          ? DateTime.parse(lastSyncAtStr).toUtc()
          : DateTime.fromMillisecondsSinceEpoch(0).toUtc();

      // Manual token fallback to ensure 200 OK
      final token = await ref.read(authLocalDatasourceProvider).getAccessToken();
      if (token != null) {
        apiClient.setToken(token);
      }

      final pendingTasks = await localDatasource.getPendingSyncTasks();
      dev.log('TaskRepository: Found ${pendingTasks.length} pending tasks');

      final created = pendingTasks
          .where((t) => t.deletedAt == null)
          .map(_entryToApiDto)
          .toList();
          
      final updated = <api.TaskDto>[]; 
          
      final deleted = pendingTasks
          .where((t) => t.deletedAt != null)
          .map((t) => api.DeletedTaskDto(id: t.id))
          .toList();

      dev.log('TaskRepository: Sending sync request. Items: ${created.length}, Deleted: ${deleted.length}');
      
      final response = await apiClient.sync.sync(
        api.SyncRequest(
          last_sync_at: lastSyncAt,
          changes: api.SyncChanges(
            created: created,
            updated: updated,
            deleted: deleted,
          ),
        ),
      );

      await _applyServerChanges(response.changes);

      for (final task in pendingTasks) {
        await localDatasource.markAsSynced(task.id);
      }

      // Save sync time in clean ISO format
      final cleanSyncAt = response.sync_at.toUtc().toIso8601String();
      await _setMetadata('last_sync_at', cleanSyncAt);
      
      dev.log('TaskRepository: Sync completed successfully (200 OK)');
    } catch (e, st) {
      dev.log('TaskRepository: Sync failed: $e', stackTrace: st);
    }
  }

  Future<void> _applyServerChanges(api.SyncChanges changes) async {
    final toUpsert = [
      ...changes.created.map(_apiDtoToEntry),
      ...changes.updated.map(_apiDtoToEntry),
    ];

    if (toUpsert.isNotEmpty) {
      await localDatasource.upsertTasks(toUpsert);
    }
  }

  @override
  Future<void> addTask(Task task) async {
    dev.log('TaskRepository: addTask() called for: ${task.title}');
    final entry = _entityToEntry(task).copyWith(isPendingSync: true);
    try {
      await localDatasource.upsertTask(entry);
      dev.log('TaskRepository: Task saved locally');
      unawaited(syncTasks());
    } catch (e) {
      dev.log('TaskRepository: Error adding task: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    final entry = _entityToEntry(task).copyWith(
      isPendingSync: true,
      updatedAt: DateTime.now(),
    );
    await localDatasource.upsertTask(entry);
    unawaited(syncTasks());
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDatasource.deleteTask(id);
    unawaited(syncTasks());
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    final entry = await localDatasource.getTaskById(id);
    if (entry != null) {
      final updated = entry.copyWith(
        completed: !entry.completed,
        isPendingSync: true,
        updatedAt: DateTime.now(),
      );
      await localDatasource.upsertTask(updated);
      unawaited(syncTasks());
    }
  }

  // Helpers
  Task _entryToEntity(TaskEntry entry) {
    return Task(
      id: entry.id,
      title: entry.title,
      description: entry.description,
      type: entry.type == 'recurrent' ? TaskType.recurrent : TaskType.oneTime,
      completed: entry.completed,
      timeTriggerAt: entry.timeTriggerAt,
      geoTriggerLatitude: entry.geoTriggerLatitude,
      geoTriggerLongitude: entry.geoTriggerLongitude,
      geoTriggerRadius: entry.geoTriggerRadius,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  TaskEntry _entityToEntry(Task entity) {
    return TaskEntry(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      type: entity.type == TaskType.recurrent ? 'recurrent' : 'one_time',
      completed: entity.completed,
      timeTriggerAt: entity.timeTriggerAt,
      geoTriggerLatitude: entity.geoTriggerLatitude,
      geoTriggerLongitude: entity.geoTriggerLongitude,
      geoTriggerRadius: entity.geoTriggerRadius,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isPendingSync: false,
    );
  }

  api.TaskDto _entryToApiDto(TaskEntry entry) {
    return api.TaskDto(
      id: entry.id,
      title: entry.title,
      description: entry.description,
      type: entry.type,
      completed: entry.completed,
      timeTriggerAt: entry.timeTriggerAt?.toUtc(),
      geoTriggerLatitude: entry.geoTriggerLatitude,
      geoTriggerLongitude: entry.geoTriggerLongitude,
      geoTriggerRadius: entry.geoTriggerRadius,
      createdAt: entry.createdAt.toUtc(),
      updatedAt: entry.updatedAt.toUtc(),
    );
  }

  TaskEntry _apiDtoToEntry(api.TaskDto dto) {
    return TaskEntry(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      type: dto.type,
      completed: dto.completed,
      timeTriggerAt: dto.timeTriggerAt,
      geoTriggerLatitude: dto.geoTriggerLatitude,
      geoTriggerLongitude: dto.geoTriggerLongitude,
      geoTriggerRadius: dto.geoTriggerRadius,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt ?? DateTime.now(),
      isPendingSync: false,
    );
  }

  Future<String?> _getMetadata(String key) async {
    final db = (localDatasource as TaskLocalDatasource).db;
    final entry = await (db.select(db.appMetadata)..where((t) => t.key.equals(key))).getSingleOrNull();
    return entry?.value;
  }

  Future<void> _setMetadata(String key, String value) async {
    final db = (localDatasource as TaskLocalDatasource).db;
    await db.into(db.appMetadata).insertOnConflictUpdate(
      AppMetadataEntry(key: key, value: value),
    );
  }
}

@riverpod
ITaskRepository taskRepository(Ref ref) {
  return TaskRepositoryImpl(
    localDatasource: ref.watch(taskLocalDatasourceProvider),
    apiClient: ref.watch(apiClientProvider),
    ref: ref,
  );
}
