import 'package:json_annotation/json_annotation.dart';
import 'task_dto.dart';

part 'sync_dto.g.dart';

@JsonSerializable()
class SyncRequestDto {
  final DateTime lastSyncAt;
  final SyncChangesDto changes;

  SyncRequestDto({
    required this.lastSyncAt,
    required this.changes,
  });

  factory SyncRequestDto.fromJson(Map<String, dynamic> json) => _$SyncRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SyncRequestDtoToJson(this);
}

@JsonSerializable()
class SyncChangesDto {
  final List<TaskDto> created;
  final List<TaskDto> updated;
  final List<String> deleted; // IDs of deleted tasks

  SyncChangesDto({
    required this.created,
    required this.updated,
    required this.deleted,
  });

  factory SyncChangesDto.fromJson(Map<String, dynamic> json) => _$SyncChangesDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SyncChangesDtoToJson(this);
}

@JsonSerializable()
class SyncResponseDto {
  final DateTime syncAt;
  final SyncChangesDto changes;

  SyncResponseDto({
    required this.syncAt,
    required this.changes,
  });

  factory SyncResponseDto.fromJson(Map<String, dynamic> json) => _$SyncResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SyncResponseDtoToJson(this);
}
