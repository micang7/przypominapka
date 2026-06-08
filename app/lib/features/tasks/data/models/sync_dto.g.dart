// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncRequestDto _$SyncRequestDtoFromJson(Map<String, dynamic> json) =>
    SyncRequestDto(
      lastSyncAt: DateTime.parse(json['lastSyncAt'] as String),
      changes: SyncChangesDto.fromJson(json['changes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SyncRequestDtoToJson(SyncRequestDto instance) =>
    <String, dynamic>{
      'lastSyncAt': instance.lastSyncAt.toIso8601String(),
      'changes': instance.changes.toJson(),
    };

SyncChangesDto _$SyncChangesDtoFromJson(Map<String, dynamic> json) =>
    SyncChangesDto(
      created: (json['created'] as List<dynamic>)
          .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      updated: (json['updated'] as List<dynamic>)
          .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      deleted: (json['deleted'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SyncChangesDtoToJson(SyncChangesDto instance) =>
    <String, dynamic>{
      'created': instance.created.map((e) => e.toJson()).toList(),
      'updated': instance.updated.map((e) => e.toJson()).toList(),
      'deleted': instance.deleted,
    };

SyncResponseDto _$SyncResponseDtoFromJson(Map<String, dynamic> json) =>
    SyncResponseDto(
      syncAt: DateTime.parse(json['syncAt'] as String),
      changes: SyncChangesDto.fromJson(json['changes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SyncResponseDtoToJson(SyncResponseDto instance) =>
    <String, dynamic>{
      'syncAt': instance.syncAt.toIso8601String(),
      'changes': instance.changes.toJson(),
    };
