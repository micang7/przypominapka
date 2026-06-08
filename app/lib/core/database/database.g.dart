// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _timeTriggerAtMeta = const VerificationMeta(
    'timeTriggerAt',
  );
  @override
  late final GeneratedColumn<DateTime> timeTriggerAt =
      GeneratedColumn<DateTime>(
        'time_trigger_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _geoTriggerLatitudeMeta =
      const VerificationMeta('geoTriggerLatitude');
  @override
  late final GeneratedColumn<double> geoTriggerLatitude =
      GeneratedColumn<double>(
        'geo_trigger_latitude',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _geoTriggerLongitudeMeta =
      const VerificationMeta('geoTriggerLongitude');
  @override
  late final GeneratedColumn<double> geoTriggerLongitude =
      GeneratedColumn<double>(
        'geo_trigger_longitude',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _geoTriggerRadiusMeta = const VerificationMeta(
    'geoTriggerRadius',
  );
  @override
  late final GeneratedColumn<int> geoTriggerRadius = GeneratedColumn<int>(
    'geo_trigger_radius',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPendingSyncMeta = const VerificationMeta(
    'isPendingSync',
  );
  @override
  late final GeneratedColumn<bool> isPendingSync = GeneratedColumn<bool>(
    'is_pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    type,
    completed,
    timeTriggerAt,
    geoTriggerLatitude,
    geoTriggerLongitude,
    geoTriggerRadius,
    createdAt,
    updatedAt,
    deletedAt,
    isPendingSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('time_trigger_at')) {
      context.handle(
        _timeTriggerAtMeta,
        timeTriggerAt.isAcceptableOrUnknown(
          data['time_trigger_at']!,
          _timeTriggerAtMeta,
        ),
      );
    }
    if (data.containsKey('geo_trigger_latitude')) {
      context.handle(
        _geoTriggerLatitudeMeta,
        geoTriggerLatitude.isAcceptableOrUnknown(
          data['geo_trigger_latitude']!,
          _geoTriggerLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('geo_trigger_longitude')) {
      context.handle(
        _geoTriggerLongitudeMeta,
        geoTriggerLongitude.isAcceptableOrUnknown(
          data['geo_trigger_longitude']!,
          _geoTriggerLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('geo_trigger_radius')) {
      context.handle(
        _geoTriggerRadiusMeta,
        geoTriggerRadius.isAcceptableOrUnknown(
          data['geo_trigger_radius']!,
          _geoTriggerRadiusMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_pending_sync')) {
      context.handle(
        _isPendingSyncMeta,
        isPendingSync.isAcceptableOrUnknown(
          data['is_pending_sync']!,
          _isPendingSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      timeTriggerAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time_trigger_at'],
      ),
      geoTriggerLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}geo_trigger_latitude'],
      ),
      geoTriggerLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}geo_trigger_longitude'],
      ),
      geoTriggerRadius: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}geo_trigger_radius'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      isPendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_sync'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskEntry extends DataClass implements Insertable<TaskEntry> {
  final String id;
  final String title;
  final String? description;
  final String type;
  final bool completed;
  final DateTime? timeTriggerAt;
  final double? geoTriggerLatitude;
  final double? geoTriggerLongitude;
  final int? geoTriggerRadius;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isPendingSync;
  const TaskEntry({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.completed,
    this.timeTriggerAt,
    this.geoTriggerLatitude,
    this.geoTriggerLongitude,
    this.geoTriggerRadius,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isPendingSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || timeTriggerAt != null) {
      map['time_trigger_at'] = Variable<DateTime>(timeTriggerAt);
    }
    if (!nullToAbsent || geoTriggerLatitude != null) {
      map['geo_trigger_latitude'] = Variable<double>(geoTriggerLatitude);
    }
    if (!nullToAbsent || geoTriggerLongitude != null) {
      map['geo_trigger_longitude'] = Variable<double>(geoTriggerLongitude);
    }
    if (!nullToAbsent || geoTriggerRadius != null) {
      map['geo_trigger_radius'] = Variable<int>(geoTriggerRadius);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_pending_sync'] = Variable<bool>(isPendingSync);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      completed: Value(completed),
      timeTriggerAt: timeTriggerAt == null && nullToAbsent
          ? const Value.absent()
          : Value(timeTriggerAt),
      geoTriggerLatitude: geoTriggerLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(geoTriggerLatitude),
      geoTriggerLongitude: geoTriggerLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(geoTriggerLongitude),
      geoTriggerRadius: geoTriggerRadius == null && nullToAbsent
          ? const Value.absent()
          : Value(geoTriggerRadius),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isPendingSync: Value(isPendingSync),
    );
  }

  factory TaskEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      completed: serializer.fromJson<bool>(json['completed']),
      timeTriggerAt: serializer.fromJson<DateTime?>(json['timeTriggerAt']),
      geoTriggerLatitude: serializer.fromJson<double?>(
        json['geoTriggerLatitude'],
      ),
      geoTriggerLongitude: serializer.fromJson<double?>(
        json['geoTriggerLongitude'],
      ),
      geoTriggerRadius: serializer.fromJson<int?>(json['geoTriggerRadius']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isPendingSync: serializer.fromJson<bool>(json['isPendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'completed': serializer.toJson<bool>(completed),
      'timeTriggerAt': serializer.toJson<DateTime?>(timeTriggerAt),
      'geoTriggerLatitude': serializer.toJson<double?>(geoTriggerLatitude),
      'geoTriggerLongitude': serializer.toJson<double?>(geoTriggerLongitude),
      'geoTriggerRadius': serializer.toJson<int?>(geoTriggerRadius),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isPendingSync': serializer.toJson<bool>(isPendingSync),
    };
  }

  TaskEntry copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? type,
    bool? completed,
    Value<DateTime?> timeTriggerAt = const Value.absent(),
    Value<double?> geoTriggerLatitude = const Value.absent(),
    Value<double?> geoTriggerLongitude = const Value.absent(),
    Value<int?> geoTriggerRadius = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? isPendingSync,
  }) => TaskEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    type: type ?? this.type,
    completed: completed ?? this.completed,
    timeTriggerAt: timeTriggerAt.present
        ? timeTriggerAt.value
        : this.timeTriggerAt,
    geoTriggerLatitude: geoTriggerLatitude.present
        ? geoTriggerLatitude.value
        : this.geoTriggerLatitude,
    geoTriggerLongitude: geoTriggerLongitude.present
        ? geoTriggerLongitude.value
        : this.geoTriggerLongitude,
    geoTriggerRadius: geoTriggerRadius.present
        ? geoTriggerRadius.value
        : this.geoTriggerRadius,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isPendingSync: isPendingSync ?? this.isPendingSync,
  );
  TaskEntry copyWithCompanion(TasksCompanion data) {
    return TaskEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      completed: data.completed.present ? data.completed.value : this.completed,
      timeTriggerAt: data.timeTriggerAt.present
          ? data.timeTriggerAt.value
          : this.timeTriggerAt,
      geoTriggerLatitude: data.geoTriggerLatitude.present
          ? data.geoTriggerLatitude.value
          : this.geoTriggerLatitude,
      geoTriggerLongitude: data.geoTriggerLongitude.present
          ? data.geoTriggerLongitude.value
          : this.geoTriggerLongitude,
      geoTriggerRadius: data.geoTriggerRadius.present
          ? data.geoTriggerRadius.value
          : this.geoTriggerRadius,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isPendingSync: data.isPendingSync.present
          ? data.isPendingSync.value
          : this.isPendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('completed: $completed, ')
          ..write('timeTriggerAt: $timeTriggerAt, ')
          ..write('geoTriggerLatitude: $geoTriggerLatitude, ')
          ..write('geoTriggerLongitude: $geoTriggerLongitude, ')
          ..write('geoTriggerRadius: $geoTriggerRadius, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isPendingSync: $isPendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    type,
    completed,
    timeTriggerAt,
    geoTriggerLatitude,
    geoTriggerLongitude,
    geoTriggerRadius,
    createdAt,
    updatedAt,
    deletedAt,
    isPendingSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.completed == this.completed &&
          other.timeTriggerAt == this.timeTriggerAt &&
          other.geoTriggerLatitude == this.geoTriggerLatitude &&
          other.geoTriggerLongitude == this.geoTriggerLongitude &&
          other.geoTriggerRadius == this.geoTriggerRadius &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isPendingSync == this.isPendingSync);
}

class TasksCompanion extends UpdateCompanion<TaskEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> type;
  final Value<bool> completed;
  final Value<DateTime?> timeTriggerAt;
  final Value<double?> geoTriggerLatitude;
  final Value<double?> geoTriggerLongitude;
  final Value<int?> geoTriggerRadius;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isPendingSync;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.completed = const Value.absent(),
    this.timeTriggerAt = const Value.absent(),
    this.geoTriggerLatitude = const Value.absent(),
    this.geoTriggerLongitude = const Value.absent(),
    this.geoTriggerRadius = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isPendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required String type,
    this.completed = const Value.absent(),
    this.timeTriggerAt = const Value.absent(),
    this.geoTriggerLatitude = const Value.absent(),
    this.geoTriggerLongitude = const Value.absent(),
    this.geoTriggerRadius = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.isPendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? type,
    Expression<bool>? completed,
    Expression<DateTime>? timeTriggerAt,
    Expression<double>? geoTriggerLatitude,
    Expression<double>? geoTriggerLongitude,
    Expression<int>? geoTriggerRadius,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isPendingSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (completed != null) 'completed': completed,
      if (timeTriggerAt != null) 'time_trigger_at': timeTriggerAt,
      if (geoTriggerLatitude != null)
        'geo_trigger_latitude': geoTriggerLatitude,
      if (geoTriggerLongitude != null)
        'geo_trigger_longitude': geoTriggerLongitude,
      if (geoTriggerRadius != null) 'geo_trigger_radius': geoTriggerRadius,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isPendingSync != null) 'is_pending_sync': isPendingSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? type,
    Value<bool>? completed,
    Value<DateTime?>? timeTriggerAt,
    Value<double?>? geoTriggerLatitude,
    Value<double?>? geoTriggerLongitude,
    Value<int?>? geoTriggerRadius,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<bool>? isPendingSync,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      completed: completed ?? this.completed,
      timeTriggerAt: timeTriggerAt ?? this.timeTriggerAt,
      geoTriggerLatitude: geoTriggerLatitude ?? this.geoTriggerLatitude,
      geoTriggerLongitude: geoTriggerLongitude ?? this.geoTriggerLongitude,
      geoTriggerRadius: geoTriggerRadius ?? this.geoTriggerRadius,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (timeTriggerAt.present) {
      map['time_trigger_at'] = Variable<DateTime>(timeTriggerAt.value);
    }
    if (geoTriggerLatitude.present) {
      map['geo_trigger_latitude'] = Variable<double>(geoTriggerLatitude.value);
    }
    if (geoTriggerLongitude.present) {
      map['geo_trigger_longitude'] = Variable<double>(
        geoTriggerLongitude.value,
      );
    }
    if (geoTriggerRadius.present) {
      map['geo_trigger_radius'] = Variable<int>(geoTriggerRadius.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isPendingSync.present) {
      map['is_pending_sync'] = Variable<bool>(isPendingSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('completed: $completed, ')
          ..write('timeTriggerAt: $timeTriggerAt, ')
          ..write('geoTriggerLatitude: $geoTriggerLatitude, ')
          ..write('geoTriggerLongitude: $geoTriggerLongitude, ')
          ..write('geoTriggerRadius: $geoTriggerRadius, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isPendingSync: $isPendingSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppMetadataTable extends AppMetadata
    with TableInfo<$AppMetadataTable, AppMetadataEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetadataTable createAlias(String alias) {
    return $AppMetadataTable(attachedDatabase, alias);
  }
}

class AppMetadataEntry extends DataClass
    implements Insertable<AppMetadataEntry> {
  final String key;
  final String value;
  const AppMetadataEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetadataCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetadataEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetadataEntry copyWith({String? key, String? value}) =>
      AppMetadataEntry(key: key ?? this.key, value: value ?? this.value);
  AppMetadataEntry copyWithCompanion(AppMetadataCompanion data) {
    return AppMetadataEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetadataCompanion extends UpdateCompanion<AppMetadataEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetadataEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $AppMetadataTable appMetadata = $AppMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasks, appMetadata];
}

typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      required String type,
      Value<bool> completed,
      Value<DateTime?> timeTriggerAt,
      Value<double?> geoTriggerLatitude,
      Value<double?> geoTriggerLongitude,
      Value<int?> geoTriggerRadius,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<bool> isPendingSync,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String> type,
      Value<bool> completed,
      Value<DateTime?> timeTriggerAt,
      Value<double?> geoTriggerLatitude,
      Value<double?> geoTriggerLongitude,
      Value<int?> geoTriggerRadius,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<bool> isPendingSync,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timeTriggerAt => $composableBuilder(
    column: $table.timeTriggerAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get geoTriggerLatitude => $composableBuilder(
    column: $table.geoTriggerLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get geoTriggerLongitude => $composableBuilder(
    column: $table.geoTriggerLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get geoTriggerRadius => $composableBuilder(
    column: $table.geoTriggerRadius,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timeTriggerAt => $composableBuilder(
    column: $table.timeTriggerAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get geoTriggerLatitude => $composableBuilder(
    column: $table.geoTriggerLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get geoTriggerLongitude => $composableBuilder(
    column: $table.geoTriggerLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get geoTriggerRadius => $composableBuilder(
    column: $table.geoTriggerRadius,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get timeTriggerAt => $composableBuilder(
    column: $table.timeTriggerAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get geoTriggerLatitude => $composableBuilder(
    column: $table.geoTriggerLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get geoTriggerLongitude => $composableBuilder(
    column: $table.geoTriggerLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<int> get geoTriggerRadius => $composableBuilder(
    column: $table.geoTriggerRadius,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskEntry,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskEntry, BaseReferences<_$AppDatabase, $TasksTable, TaskEntry>),
          TaskEntry,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> timeTriggerAt = const Value.absent(),
                Value<double?> geoTriggerLatitude = const Value.absent(),
                Value<double?> geoTriggerLongitude = const Value.absent(),
                Value<int?> geoTriggerRadius = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> isPendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                description: description,
                type: type,
                completed: completed,
                timeTriggerAt: timeTriggerAt,
                geoTriggerLatitude: geoTriggerLatitude,
                geoTriggerLongitude: geoTriggerLongitude,
                geoTriggerRadius: geoTriggerRadius,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isPendingSync: isPendingSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required String type,
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> timeTriggerAt = const Value.absent(),
                Value<double?> geoTriggerLatitude = const Value.absent(),
                Value<double?> geoTriggerLongitude = const Value.absent(),
                Value<int?> geoTriggerRadius = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> isPendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                description: description,
                type: type,
                completed: completed,
                timeTriggerAt: timeTriggerAt,
                geoTriggerLatitude: geoTriggerLatitude,
                geoTriggerLongitude: geoTriggerLongitude,
                geoTriggerRadius: geoTriggerRadius,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isPendingSync: isPendingSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskEntry,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskEntry, BaseReferences<_$AppDatabase, $TasksTable, TaskEntry>),
      TaskEntry,
      PrefetchHooks Function()
    >;
typedef $$AppMetadataTableCreateCompanionBuilder =
    AppMetadataCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetadataTableUpdateCompanionBuilder =
    AppMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTable,
          AppMetadataEntry,
          $$AppMetadataTableFilterComposer,
          $$AppMetadataTableOrderingComposer,
          $$AppMetadataTableAnnotationComposer,
          $$AppMetadataTableCreateCompanionBuilder,
          $$AppMetadataTableUpdateCompanionBuilder,
          (
            AppMetadataEntry,
            BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataEntry>,
          ),
          AppMetadataEntry,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableManager(_$AppDatabase db, $AppMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTable,
      AppMetadataEntry,
      $$AppMetadataTableFilterComposer,
      $$AppMetadataTableOrderingComposer,
      $$AppMetadataTableAnnotationComposer,
      $$AppMetadataTableCreateCompanionBuilder,
      $$AppMetadataTableUpdateCompanionBuilder,
      (
        AppMetadataEntry,
        BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataEntry>,
      ),
      AppMetadataEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$AppMetadataTableTableManager get appMetadata =>
      $$AppMetadataTableTableManager(_db, _db.appMetadata);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'e46f17e24104d6c9f582325105140e8720d5da27';
