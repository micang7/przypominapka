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
    required int version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) => _$TaskDtoFromJson(json);
}

@freezed
abstract class DeletedTaskDto with _$DeletedTaskDto {
  const factory DeletedTaskDto({
    required String id,
  }) = _DeletedTaskDto;

  factory DeletedTaskDto.fromJson(Map<String, dynamic> json) => _$DeletedTaskDtoFromJson(json);
}

@freezed
abstract class SyncChanges with _$SyncChanges {
  const factory SyncChanges({
    @Default([]) List<TaskDto> created,
    @Default([]) List<TaskDto> updated,
    @Default([]) List<DeletedTaskDto> deleted,
  }) = _SyncChanges;

  factory SyncChanges.fromJson(Map<String, dynamic> json) => _$SyncChangesFromJson(json);
}

@freezed
abstract class SyncRequest with _$SyncRequest {
  const factory SyncRequest({
    @JsonKey(name: 'last_sync_at') required DateTime lastSyncAt,
    required SyncChanges changes,
    required String deviceId,
  }) = _SyncRequest;

  factory SyncRequest.fromJson(Map<String, dynamic> json) => _$SyncRequestFromJson(json);
}

@freezed
abstract class SyncResponse with _$SyncResponse {
  const factory SyncResponse({
    @JsonKey(name: 'sync_at') required DateTime syncAt,
    required SyncChanges changes,
  }) = _SyncResponse;

  factory SyncResponse.fromJson(Map<String, dynamic> json) => _$SyncResponseFromJson(json);
}

@freezed
abstract class SessionsUpdateFcmTokenDto with _$SessionsUpdateFcmTokenDto {
  const factory SessionsUpdateFcmTokenDto({
    required String deviceId,
    required String fcmToken,
  }) = _SessionsUpdateFcmTokenDto;

  factory SessionsUpdateFcmTokenDto.fromJson(Map<String, dynamic> json) => _$SessionsUpdateFcmTokenDtoFromJson(json);
}
