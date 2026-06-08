// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => TaskDto(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  type: json['type'] as String,
  completed: json['completed'] as bool,
  timeTriggerAt: json['timeTriggerAt'] == null
      ? null
      : DateTime.parse(json['timeTriggerAt'] as String),
  geoTriggerLatitude: (json['geoTriggerLatitude'] as num?)?.toDouble(),
  geoTriggerLongitude: (json['geoTriggerLongitude'] as num?)?.toDouble(),
  geoTriggerRadius: (json['geoTriggerRadius'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'type': instance.type,
  'completed': instance.completed,
  'timeTriggerAt': instance.timeTriggerAt?.toIso8601String(),
  'geoTriggerLatitude': instance.geoTriggerLatitude,
  'geoTriggerLongitude': instance.geoTriggerLongitude,
  'geoTriggerRadius': instance.geoTriggerRadius,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
