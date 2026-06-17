// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => _TaskDto(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  type: json['type'] as String,
  completed: json['completed'] as bool? ?? false,
  timeTriggerAt: json['timeTriggerAt'] == null
      ? null
      : DateTime.parse(json['timeTriggerAt'] as String),
  geoTriggerLatitude: (json['geoTriggerLatitude'] as num?)?.toDouble(),
  geoTriggerLongitude: (json['geoTriggerLongitude'] as num?)?.toDouble(),
  geoTriggerRadius: (json['geoTriggerRadius'] as num?)?.toInt(),
  version: (json['version'] as num).toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TaskDtoToJson(_TaskDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'type': instance.type,
  'completed': instance.completed,
  'timeTriggerAt': instance.timeTriggerAt?.toIso8601String(),
  'geoTriggerLatitude': instance.geoTriggerLatitude,
  'geoTriggerLongitude': instance.geoTriggerLongitude,
  'geoTriggerRadius': instance.geoTriggerRadius,
  'version': instance.version,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_DeletedTaskDto _$DeletedTaskDtoFromJson(Map<String, dynamic> json) =>
    _DeletedTaskDto(id: json['id'] as String);

Map<String, dynamic> _$DeletedTaskDtoToJson(_DeletedTaskDto instance) =>
    <String, dynamic>{'id': instance.id};

_SyncChanges _$SyncChangesFromJson(Map<String, dynamic> json) => _SyncChanges(
  created:
      (json['created'] as List<dynamic>?)
          ?.map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  updated:
      (json['updated'] as List<dynamic>?)
          ?.map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  deleted:
      (json['deleted'] as List<dynamic>?)
          ?.map((e) => DeletedTaskDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SyncChangesToJson(_SyncChanges instance) =>
    <String, dynamic>{
      'created': instance.created.map((e) => e.toJson()).toList(),
      'updated': instance.updated.map((e) => e.toJson()).toList(),
      'deleted': instance.deleted.map((e) => e.toJson()).toList(),
    };

_SyncRequest _$SyncRequestFromJson(Map<String, dynamic> json) => _SyncRequest(
  lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
  changes: SyncChanges.fromJson(json['changes'] as Map<String, dynamic>),
  deviceId: json['deviceId'] as String,
);

Map<String, dynamic> _$SyncRequestToJson(_SyncRequest instance) =>
    <String, dynamic>{
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'changes': instance.changes.toJson(),
      'deviceId': instance.deviceId,
    };

_SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) =>
    _SyncResponse(
      syncAt: DateTime.parse(json['sync_at'] as String),
      changes: SyncChanges.fromJson(json['changes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SyncResponseToJson(_SyncResponse instance) =>
    <String, dynamic>{
      'sync_at': instance.syncAt.toIso8601String(),
      'changes': instance.changes.toJson(),
    };

_SessionsUpdateFcmTokenDto _$SessionsUpdateFcmTokenDtoFromJson(
  Map<String, dynamic> json,
) => _SessionsUpdateFcmTokenDto(
  deviceId: json['deviceId'] as String,
  fcmToken: json['fcmToken'] as String,
);

Map<String, dynamic> _$SessionsUpdateFcmTokenDtoToJson(
  _SessionsUpdateFcmTokenDto instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'fcmToken': instance.fcmToken,
};
