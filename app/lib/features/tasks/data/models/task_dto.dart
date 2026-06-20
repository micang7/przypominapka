import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDto {
  final String id;
  final String title;
  final String? description;
  final String type; // 'one_time', 'recurrent'
  final bool completed;
  final DateTime? timeTriggerAt;
  final double? geoTriggerLatitude;
  final double? geoTriggerLongitude;
  final int? geoTriggerRadius;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskDto({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.completed,
    this.timeTriggerAt,
    this.geoTriggerLatitude,
    this.geoTriggerLongitude,
    this.geoTriggerRadius,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) => _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      type: type == 'recurrent' ? TaskType.recurrent : TaskType.oneTime,
      completed: completed,
      timeTriggerAt: timeTriggerAt,
      geoTriggerLatitude: geoTriggerLatitude,
      geoTriggerLongitude: geoTriggerLongitude,
      geoTriggerRadius: geoTriggerRadius,
      version: version,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TaskDto.fromEntity(Task task) {
    return TaskDto(
      id: task.id,
      title: task.title,
      description: task.description,
      type: task.type == TaskType.recurrent ? 'recurrent' : 'one_time',
      completed: task.completed,
      timeTriggerAt: task.timeTriggerAt,
      geoTriggerLatitude: task.geoTriggerLatitude,
      geoTriggerLongitude: task.geoTriggerLongitude,
      geoTriggerRadius: task.geoTriggerRadius,
      version: task.version,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }
}
