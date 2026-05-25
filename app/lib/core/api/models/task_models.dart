import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_models.freezed.dart';
part 'task_models.g.dart';

@freezed
abstract class TaskDto with _$TaskDto {
  const factory TaskDto({
    required String id,
    required String title,
    String? description,
    required String type, // 'one_time', 'recurrent'
    @Default(false) bool completed,
    DateTime? timeTriggerAt,
    double? geoTriggerLatitude,
    double? geoTriggerLongitude,
    int? geoTriggerRadius,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) => _$TaskDtoFromJson(json);
}

@freezed
abstract class SyncChanges with _$SyncChanges {
  const factory SyncChanges({
    @Default([]) List<TaskDto> created,
    @Default([]) List<TaskDto> updated,
    @Default([]) List<String> deleted,
  }) = _SyncChanges;

  factory SyncChanges.fromJson(Map<String, dynamic> json) => _$SyncChangesFromJson(json);
}

@freezed
abstract class SyncRequest with _$SyncRequest {
  const factory SyncRequest({
    required DateTime last_sync_at,
    required SyncChanges changes,
  }) = _SyncRequest;

  factory SyncRequest.fromJson(Map<String, dynamic> json) => _$SyncRequestFromJson(json);
}

@freezed
abstract class SyncResponse with _$SyncResponse {
  const factory SyncResponse({
    required DateTime sync_at,
    required SyncChanges changes,
  }) = _SyncResponse;

  factory SyncResponse.fromJson(Map<String, dynamic> json) => _$SyncResponseFromJson(json);
}
