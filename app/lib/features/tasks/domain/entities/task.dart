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
  final int version;
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
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? title,
    String? description,
    TaskType? type,
    bool? completed,
    DateTime? timeTriggerAt,
    double? geoTriggerLatitude,
    double? geoTriggerLongitude,
    int? geoTriggerRadius,
    int? version,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      completed: completed ?? this.completed,
      timeTriggerAt: timeTriggerAt ?? this.timeTriggerAt,
      geoTriggerLatitude: geoTriggerLatitude ?? this.geoTriggerLatitude,
      geoTriggerLongitude: geoTriggerLongitude ?? this.geoTriggerLongitude,
      geoTriggerRadius: geoTriggerRadius ?? this.geoTriggerRadius,
      version: version ?? this.version,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isTimeBased => timeTriggerAt != null;
  bool get isGeoBased => geoTriggerLatitude != null && geoTriggerLongitude != null;
}
