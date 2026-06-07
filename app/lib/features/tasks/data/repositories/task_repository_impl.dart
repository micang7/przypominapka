import 'dart:async';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/models/task_models.dart' as api;
import 'package:app/core/database/database.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/features/tasks/domain/repositories/task_repository_contract.dart';
import 'package:app/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:app/core/services/geofencing_service.dart';
import 'package:flutter/foundation.dart';

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
    return localDatasource.watchAllTasks().map((entries) {
      return entries.map(_entryToEntity).toList();
    });
  }

  @override
  Future<void> syncTasks() async {
    try {
      final lastSyncAtStr = await _getMetadata('last_sync_at');
      final lastSyncAt = lastSyncAtStr != null 
          ? DateTime.parse(lastSyncAtStr).toUtc()
          : DateTime.fromMillisecondsSinceEpoch(0).toUtc();

      final token = await ref.read(authLocalDatasourceProvider).getAccessToken();
      if (token != null) apiClient.setToken(token);

      final pendingTasks = await localDatasource.getPendingSyncTasks();
      final response = await apiClient.sync.sync(
        api.SyncRequest(
          last_sync_at: lastSyncAt,
          changes: api.SyncChanges(
            created: pendingTasks.where((t) => t.deletedAt == null).map(_entryToApiDto).toList(),
            updated: [],
            deleted: pendingTasks.where((t) => t.deletedAt != null).map((t) => api.DeletedTaskDto(id: t.id)).toList(),
          ),
        ),
      );

      await _applyServerChanges(response.changes);
      for (final task in pendingTasks) {
        await localDatasource.markAsSynced(task.id);
      }
      await _setMetadata('last_sync_at', response.sync_at.toUtc().toIso8601String());
    } catch (_) {}
  }

  Future<void> _applyServerChanges(api.SyncChanges changes) async {
    final toUpsert = [...changes.created.map(_apiDtoToEntry), ...changes.updated.map(_apiDtoToEntry)];
    if (toUpsert.isNotEmpty) {
      await localDatasource.upsertTasks(toUpsert);
      for (final dto in changes.created) {
        _updateTaskTriggers(
          dto.id, 
          dto.title, 
          dto.description, 
          dto.completed, 
          dto.timeTriggerAt, 
          dto.geoTriggerLatitude, 
          dto.geoTriggerLongitude, 
          dto.geoTriggerRadius?.toDouble() // Fix: cast int to double
        );
      }
    }
  }

  @override
  Future<void> addTask(Task task) async {
    final entry = _entityToEntry(task).copyWith(isPendingSync: true);
    await localDatasource.upsertTask(entry);
    _updateTaskTriggersFromEntity(task);
    unawaited(syncTasks());
  }

  @override
  Future<void> updateTask(Task task) async {
    final entry = _entityToEntry(task).copyWith(isPendingSync: true, updatedAt: DateTime.now());
    await localDatasource.upsertTask(entry);
    _updateTaskTriggersFromEntity(task);
    unawaited(syncTasks());
  }

  @override
  Future<void> deleteTask(String id) async {
    final entry = await localDatasource.getTaskById(id);
    if (entry != null) {
      ref.read(notificationServiceProvider).cancelNotification(_getNotificationId(id));
      ref.read(geofencingServiceProvider).removeGeofence(id, entry.title);
    }
    await localDatasource.deleteTask(id);
    unawaited(syncTasks());
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    final entry = await localDatasource.getTaskById(id);
    if (entry != null) {
      final updated = entry.copyWith(completed: !entry.completed, isPendingSync: true, updatedAt: DateTime.now());
      await localDatasource.upsertTask(updated);
      _updateTaskTriggers(
        updated.id, 
        updated.title, 
        updated.description, 
        updated.completed, 
        updated.timeTriggerAt, 
        updated.geoTriggerLatitude, 
        updated.geoTriggerLongitude, 
        updated.geoTriggerRadius?.toDouble() // Fix: cast int to double
      );
      unawaited(syncTasks());
    }
  }

  void _updateTaskTriggersFromEntity(Task task) {
    _updateTaskTriggers(
      task.id, 
      task.title, 
      task.description, 
      task.completed, 
      task.timeTriggerAt, 
      task.geoTriggerLatitude, 
      task.geoTriggerLongitude, 
      task.geoTriggerRadius?.toDouble()
    );
  }

  void _updateTaskTriggers(String id, String title, String? description, bool completed, DateTime? timeAt, double? lat, double? lng, double? radius) {
    if (!completed && timeAt != null) {
      ref.read(notificationServiceProvider).scheduleNotification(
        id: _getNotificationId(id),
        title: 'Zadanie: ' + title,
        body: (description != null && description.isNotEmpty) ? description : 'Czas na realizację!',
        scheduledDate: timeAt,
      );
    } else {
      ref.read(notificationServiceProvider).cancelNotification(_getNotificationId(id));
    }

    if (!completed && lat != null && lng != null && radius != null) {
      ref.read(geofencingServiceProvider).registerGeofence(
        id: id,
        title: title,
        lat: lat,
        lng: lng,
        radius: radius,
      );
    } else {
      ref.read(geofencingServiceProvider).removeGeofence(id, title);
    }
  }

  int _getNotificationId(String uuid) => uuid.hashCode.abs() % 2147483647;

  Task _entryToEntity(TaskEntry entry) => Task(id: entry.id, title: entry.title, description: entry.description, type: entry.type == 'recurrent' ? TaskType.recurrent : TaskType.oneTime, completed: entry.completed, timeTriggerAt: entry.timeTriggerAt, geoTriggerLatitude: entry.geoTriggerLatitude, geoTriggerLongitude: entry.geoTriggerLongitude, geoTriggerRadius: entry.geoTriggerRadius, createdAt: entry.createdAt, updatedAt: entry.updatedAt);
  TaskEntry _entityToEntry(Task entity) => TaskEntry(id: entity.id, title: entity.title, description: entity.description, type: entity.type == TaskType.recurrent ? 'recurrent' : 'one_time', completed: entity.completed, timeTriggerAt: entity.timeTriggerAt, geoTriggerLatitude: entity.geoTriggerLatitude, geoTriggerLongitude: entity.geoTriggerLongitude, geoTriggerRadius: entity.geoTriggerRadius, createdAt: entity.createdAt, updatedAt: entity.updatedAt, isPendingSync: false);
  api.TaskDto _entryToApiDto(TaskEntry entry) => api.TaskDto(id: entry.id, title: entry.title, description: entry.description, type: entry.type, completed: entry.completed, timeTriggerAt: entry.timeTriggerAt?.toUtc(), geoTriggerLatitude: entry.geoTriggerLatitude, geoTriggerLongitude: entry.geoTriggerLongitude, geoTriggerRadius: entry.geoTriggerRadius, createdAt: entry.createdAt.toUtc(), updatedAt: entry.updatedAt.toUtc());
  TaskEntry _apiDtoToEntry(api.TaskDto dto) => TaskEntry(id: dto.id, title: dto.title, description: dto.description, type: dto.type, completed: dto.completed, timeTriggerAt: dto.timeTriggerAt, geoTriggerLatitude: dto.geoTriggerLatitude, geoTriggerLongitude: dto.geoTriggerLongitude, geoTriggerRadius: dto.geoTriggerRadius, createdAt: dto.createdAt ?? DateTime.now(), updatedAt: dto.updatedAt ?? DateTime.now(), isPendingSync: false);
  Future<String?> _getMetadata(String key) async { final db = (localDatasource as TaskLocalDatasource).db; final entry = await (db.select(db.appMetadata)..where((t) => t.key.equals(key))).getSingleOrNull(); return entry?.value; }
  Future<void> _setMetadata(String key, String value) async { final db = (localDatasource as TaskLocalDatasource).db; await db.into(db.appMetadata).insertOnConflictUpdate(AppMetadataEntry(key: key, value: value)); }
}

@riverpod
ITaskRepository taskRepository(Ref ref) => TaskRepositoryImpl(localDatasource: ref.watch(taskLocalDatasourceProvider), apiClient: ref.watch(apiClientProvider), ref: ref);
