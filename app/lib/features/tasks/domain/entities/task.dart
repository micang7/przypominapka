enum TaskType {
  oneTime,
  recurrent,
}

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskType type;
  final bool completed;
  final DateTime? timeTriggerAt;
  final double? geoTriggerLatitude;
  final double? geoTriggerLongitude;
  final int? geoTriggerRadius;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.completed = false,
    this.timeTriggerAt,
    this.geoTriggerLatitude,
    this.geoTriggerLongitude,
    this.geoTriggerRadius,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isTimeBased => timeTriggerAt != null;
  bool get isGeoBased => geoTriggerLatitude != null && geoTriggerLongitude != null;
}
