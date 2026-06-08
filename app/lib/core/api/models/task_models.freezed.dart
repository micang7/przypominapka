// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskDto {

 String get id; String get title; String? get description; String get type;// 'one_time', 'recurrent'
 bool get completed; DateTime? get timeTriggerAt; double? get geoTriggerLatitude; double? get geoTriggerLongitude; int? get geoTriggerRadius; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of TaskDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDtoCopyWith<TaskDto> get copyWith => _$TaskDtoCopyWithImpl<TaskDto>(this as TaskDto, _$identity);

  /// Serializes this TaskDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.timeTriggerAt, timeTriggerAt) || other.timeTriggerAt == timeTriggerAt)&&(identical(other.geoTriggerLatitude, geoTriggerLatitude) || other.geoTriggerLatitude == geoTriggerLatitude)&&(identical(other.geoTriggerLongitude, geoTriggerLongitude) || other.geoTriggerLongitude == geoTriggerLongitude)&&(identical(other.geoTriggerRadius, geoTriggerRadius) || other.geoTriggerRadius == geoTriggerRadius)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,type,completed,timeTriggerAt,geoTriggerLatitude,geoTriggerLongitude,geoTriggerRadius,createdAt,updatedAt);

@override
String toString() {
  return 'TaskDto(id: $id, title: $title, description: $description, type: $type, completed: $completed, timeTriggerAt: $timeTriggerAt, geoTriggerLatitude: $geoTriggerLatitude, geoTriggerLongitude: $geoTriggerLongitude, geoTriggerRadius: $geoTriggerRadius, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TaskDtoCopyWith<$Res>  {
  factory $TaskDtoCopyWith(TaskDto value, $Res Function(TaskDto) _then) = _$TaskDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String type, bool completed, DateTime? timeTriggerAt, double? geoTriggerLatitude, double? geoTriggerLongitude, int? geoTriggerRadius, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$TaskDtoCopyWithImpl<$Res>
    implements $TaskDtoCopyWith<$Res> {
  _$TaskDtoCopyWithImpl(this._self, this._then);

  final TaskDto _self;
  final $Res Function(TaskDto) _then;

/// Create a copy of TaskDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? type = null,Object? completed = null,Object? timeTriggerAt = freezed,Object? geoTriggerLatitude = freezed,Object? geoTriggerLongitude = freezed,Object? geoTriggerRadius = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,timeTriggerAt: freezed == timeTriggerAt ? _self.timeTriggerAt : timeTriggerAt // ignore: cast_nullable_to_non_nullable
as DateTime?,geoTriggerLatitude: freezed == geoTriggerLatitude ? _self.geoTriggerLatitude : geoTriggerLatitude // ignore: cast_nullable_to_non_nullable
as double?,geoTriggerLongitude: freezed == geoTriggerLongitude ? _self.geoTriggerLongitude : geoTriggerLongitude // ignore: cast_nullable_to_non_nullable
as double?,geoTriggerRadius: freezed == geoTriggerRadius ? _self.geoTriggerRadius : geoTriggerRadius // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskDto].
extension TaskDtoPatterns on TaskDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDto value)  $default,){
final _that = this;
switch (_that) {
case _TaskDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDto value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String type,  bool completed,  DateTime? timeTriggerAt,  double? geoTriggerLatitude,  double? geoTriggerLongitude,  int? geoTriggerRadius,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.type,_that.completed,_that.timeTriggerAt,_that.geoTriggerLatitude,_that.geoTriggerLongitude,_that.geoTriggerRadius,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String type,  bool completed,  DateTime? timeTriggerAt,  double? geoTriggerLatitude,  double? geoTriggerLongitude,  int? geoTriggerRadius,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TaskDto():
return $default(_that.id,_that.title,_that.description,_that.type,_that.completed,_that.timeTriggerAt,_that.geoTriggerLatitude,_that.geoTriggerLongitude,_that.geoTriggerRadius,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  String type,  bool completed,  DateTime? timeTriggerAt,  double? geoTriggerLatitude,  double? geoTriggerLongitude,  int? geoTriggerRadius,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.type,_that.completed,_that.timeTriggerAt,_that.geoTriggerLatitude,_that.geoTriggerLongitude,_that.geoTriggerRadius,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskDto implements TaskDto {
  const _TaskDto({required this.id, required this.title, this.description, required this.type, this.completed = false, this.timeTriggerAt, this.geoTriggerLatitude, this.geoTriggerLongitude, this.geoTriggerRadius, this.createdAt, this.updatedAt});
  factory _TaskDto.fromJson(Map<String, dynamic> json) => _$TaskDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  String type;
// 'one_time', 'recurrent'
@override@JsonKey() final  bool completed;
@override final  DateTime? timeTriggerAt;
@override final  double? geoTriggerLatitude;
@override final  double? geoTriggerLongitude;
@override final  int? geoTriggerRadius;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of TaskDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDtoCopyWith<_TaskDto> get copyWith => __$TaskDtoCopyWithImpl<_TaskDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.timeTriggerAt, timeTriggerAt) || other.timeTriggerAt == timeTriggerAt)&&(identical(other.geoTriggerLatitude, geoTriggerLatitude) || other.geoTriggerLatitude == geoTriggerLatitude)&&(identical(other.geoTriggerLongitude, geoTriggerLongitude) || other.geoTriggerLongitude == geoTriggerLongitude)&&(identical(other.geoTriggerRadius, geoTriggerRadius) || other.geoTriggerRadius == geoTriggerRadius)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,type,completed,timeTriggerAt,geoTriggerLatitude,geoTriggerLongitude,geoTriggerRadius,createdAt,updatedAt);

@override
String toString() {
  return 'TaskDto(id: $id, title: $title, description: $description, type: $type, completed: $completed, timeTriggerAt: $timeTriggerAt, geoTriggerLatitude: $geoTriggerLatitude, geoTriggerLongitude: $geoTriggerLongitude, geoTriggerRadius: $geoTriggerRadius, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskDtoCopyWith<$Res> implements $TaskDtoCopyWith<$Res> {
  factory _$TaskDtoCopyWith(_TaskDto value, $Res Function(_TaskDto) _then) = __$TaskDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String type, bool completed, DateTime? timeTriggerAt, double? geoTriggerLatitude, double? geoTriggerLongitude, int? geoTriggerRadius, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$TaskDtoCopyWithImpl<$Res>
    implements _$TaskDtoCopyWith<$Res> {
  __$TaskDtoCopyWithImpl(this._self, this._then);

  final _TaskDto _self;
  final $Res Function(_TaskDto) _then;

/// Create a copy of TaskDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? type = null,Object? completed = null,Object? timeTriggerAt = freezed,Object? geoTriggerLatitude = freezed,Object? geoTriggerLongitude = freezed,Object? geoTriggerRadius = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TaskDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,timeTriggerAt: freezed == timeTriggerAt ? _self.timeTriggerAt : timeTriggerAt // ignore: cast_nullable_to_non_nullable
as DateTime?,geoTriggerLatitude: freezed == geoTriggerLatitude ? _self.geoTriggerLatitude : geoTriggerLatitude // ignore: cast_nullable_to_non_nullable
as double?,geoTriggerLongitude: freezed == geoTriggerLongitude ? _self.geoTriggerLongitude : geoTriggerLongitude // ignore: cast_nullable_to_non_nullable
as double?,geoTriggerRadius: freezed == geoTriggerRadius ? _self.geoTriggerRadius : geoTriggerRadius // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DeletedTaskDto {

 String get id;
/// Create a copy of DeletedTaskDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedTaskDtoCopyWith<DeletedTaskDto> get copyWith => _$DeletedTaskDtoCopyWithImpl<DeletedTaskDto>(this as DeletedTaskDto, _$identity);

  /// Serializes this DeletedTaskDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedTaskDto&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DeletedTaskDto(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeletedTaskDtoCopyWith<$Res>  {
  factory $DeletedTaskDtoCopyWith(DeletedTaskDto value, $Res Function(DeletedTaskDto) _then) = _$DeletedTaskDtoCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DeletedTaskDtoCopyWithImpl<$Res>
    implements $DeletedTaskDtoCopyWith<$Res> {
  _$DeletedTaskDtoCopyWithImpl(this._self, this._then);

  final DeletedTaskDto _self;
  final $Res Function(DeletedTaskDto) _then;

/// Create a copy of DeletedTaskDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletedTaskDto].
extension DeletedTaskDtoPatterns on DeletedTaskDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletedTaskDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletedTaskDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletedTaskDto value)  $default,){
final _that = this;
switch (_that) {
case _DeletedTaskDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletedTaskDto value)?  $default,){
final _that = this;
switch (_that) {
case _DeletedTaskDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletedTaskDto() when $default != null:
return $default(_that.id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id)  $default,) {final _that = this;
switch (_that) {
case _DeletedTaskDto():
return $default(_that.id);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id)?  $default,) {final _that = this;
switch (_that) {
case _DeletedTaskDto() when $default != null:
return $default(_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletedTaskDto implements DeletedTaskDto {
  const _DeletedTaskDto({required this.id});
  factory _DeletedTaskDto.fromJson(Map<String, dynamic> json) => _$DeletedTaskDtoFromJson(json);

@override final  String id;

/// Create a copy of DeletedTaskDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedTaskDtoCopyWith<_DeletedTaskDto> get copyWith => __$DeletedTaskDtoCopyWithImpl<_DeletedTaskDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletedTaskDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletedTaskDto&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DeletedTaskDto(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeletedTaskDtoCopyWith<$Res> implements $DeletedTaskDtoCopyWith<$Res> {
  factory _$DeletedTaskDtoCopyWith(_DeletedTaskDto value, $Res Function(_DeletedTaskDto) _then) = __$DeletedTaskDtoCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class __$DeletedTaskDtoCopyWithImpl<$Res>
    implements _$DeletedTaskDtoCopyWith<$Res> {
  __$DeletedTaskDtoCopyWithImpl(this._self, this._then);

  final _DeletedTaskDto _self;
  final $Res Function(_DeletedTaskDto) _then;

/// Create a copy of DeletedTaskDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_DeletedTaskDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SyncChanges {

 List<TaskDto> get created; List<TaskDto> get updated; List<DeletedTaskDto> get deleted;
/// Create a copy of SyncChanges
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncChangesCopyWith<SyncChanges> get copyWith => _$SyncChangesCopyWithImpl<SyncChanges>(this as SyncChanges, _$identity);

  /// Serializes this SyncChanges to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncChanges&&const DeepCollectionEquality().equals(other.created, created)&&const DeepCollectionEquality().equals(other.updated, updated)&&const DeepCollectionEquality().equals(other.deleted, deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(created),const DeepCollectionEquality().hash(updated),const DeepCollectionEquality().hash(deleted));

@override
String toString() {
  return 'SyncChanges(created: $created, updated: $updated, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class $SyncChangesCopyWith<$Res>  {
  factory $SyncChangesCopyWith(SyncChanges value, $Res Function(SyncChanges) _then) = _$SyncChangesCopyWithImpl;
@useResult
$Res call({
 List<TaskDto> created, List<TaskDto> updated, List<DeletedTaskDto> deleted
});




}
/// @nodoc
class _$SyncChangesCopyWithImpl<$Res>
    implements $SyncChangesCopyWith<$Res> {
  _$SyncChangesCopyWithImpl(this._self, this._then);

  final SyncChanges _self;
  final $Res Function(SyncChanges) _then;

/// Create a copy of SyncChanges
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? created = null,Object? updated = null,Object? deleted = null,}) {
  return _then(_self.copyWith(
created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as List<TaskDto>,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as List<TaskDto>,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as List<DeletedTaskDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncChanges].
extension SyncChangesPatterns on SyncChanges {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncChanges value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncChanges() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncChanges value)  $default,){
final _that = this;
switch (_that) {
case _SyncChanges():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncChanges value)?  $default,){
final _that = this;
switch (_that) {
case _SyncChanges() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskDto> created,  List<TaskDto> updated,  List<DeletedTaskDto> deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncChanges() when $default != null:
return $default(_that.created,_that.updated,_that.deleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskDto> created,  List<TaskDto> updated,  List<DeletedTaskDto> deleted)  $default,) {final _that = this;
switch (_that) {
case _SyncChanges():
return $default(_that.created,_that.updated,_that.deleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskDto> created,  List<TaskDto> updated,  List<DeletedTaskDto> deleted)?  $default,) {final _that = this;
switch (_that) {
case _SyncChanges() when $default != null:
return $default(_that.created,_that.updated,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncChanges implements SyncChanges {
  const _SyncChanges({final  List<TaskDto> created = const [], final  List<TaskDto> updated = const [], final  List<DeletedTaskDto> deleted = const []}): _created = created,_updated = updated,_deleted = deleted;
  factory _SyncChanges.fromJson(Map<String, dynamic> json) => _$SyncChangesFromJson(json);

 final  List<TaskDto> _created;
@override@JsonKey() List<TaskDto> get created {
  if (_created is EqualUnmodifiableListView) return _created;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_created);
}

 final  List<TaskDto> _updated;
@override@JsonKey() List<TaskDto> get updated {
  if (_updated is EqualUnmodifiableListView) return _updated;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_updated);
}

 final  List<DeletedTaskDto> _deleted;
@override@JsonKey() List<DeletedTaskDto> get deleted {
  if (_deleted is EqualUnmodifiableListView) return _deleted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deleted);
}


/// Create a copy of SyncChanges
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncChangesCopyWith<_SyncChanges> get copyWith => __$SyncChangesCopyWithImpl<_SyncChanges>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncChangesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncChanges&&const DeepCollectionEquality().equals(other._created, _created)&&const DeepCollectionEquality().equals(other._updated, _updated)&&const DeepCollectionEquality().equals(other._deleted, _deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_created),const DeepCollectionEquality().hash(_updated),const DeepCollectionEquality().hash(_deleted));

@override
String toString() {
  return 'SyncChanges(created: $created, updated: $updated, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$SyncChangesCopyWith<$Res> implements $SyncChangesCopyWith<$Res> {
  factory _$SyncChangesCopyWith(_SyncChanges value, $Res Function(_SyncChanges) _then) = __$SyncChangesCopyWithImpl;
@override @useResult
$Res call({
 List<TaskDto> created, List<TaskDto> updated, List<DeletedTaskDto> deleted
});




}
/// @nodoc
class __$SyncChangesCopyWithImpl<$Res>
    implements _$SyncChangesCopyWith<$Res> {
  __$SyncChangesCopyWithImpl(this._self, this._then);

  final _SyncChanges _self;
  final $Res Function(_SyncChanges) _then;

/// Create a copy of SyncChanges
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? created = null,Object? updated = null,Object? deleted = null,}) {
  return _then(_SyncChanges(
created: null == created ? _self._created : created // ignore: cast_nullable_to_non_nullable
as List<TaskDto>,updated: null == updated ? _self._updated : updated // ignore: cast_nullable_to_non_nullable
as List<TaskDto>,deleted: null == deleted ? _self._deleted : deleted // ignore: cast_nullable_to_non_nullable
as List<DeletedTaskDto>,
  ));
}


}


/// @nodoc
mixin _$SyncRequest {

 DateTime get last_sync_at; SyncChanges get changes; String get deviceId;
/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncRequestCopyWith<SyncRequest> get copyWith => _$SyncRequestCopyWithImpl<SyncRequest>(this as SyncRequest, _$identity);

  /// Serializes this SyncRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncRequest&&(identical(other.last_sync_at, last_sync_at) || other.last_sync_at == last_sync_at)&&(identical(other.changes, changes) || other.changes == changes)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,last_sync_at,changes,deviceId);

@override
String toString() {
  return 'SyncRequest(last_sync_at: $last_sync_at, changes: $changes, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $SyncRequestCopyWith<$Res>  {
  factory $SyncRequestCopyWith(SyncRequest value, $Res Function(SyncRequest) _then) = _$SyncRequestCopyWithImpl;
@useResult
$Res call({
 DateTime last_sync_at, SyncChanges changes, String deviceId
});


$SyncChangesCopyWith<$Res> get changes;

}
/// @nodoc
class _$SyncRequestCopyWithImpl<$Res>
    implements $SyncRequestCopyWith<$Res> {
  _$SyncRequestCopyWithImpl(this._self, this._then);

  final SyncRequest _self;
  final $Res Function(SyncRequest) _then;

/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? last_sync_at = null,Object? changes = null,Object? deviceId = null,}) {
  return _then(_self.copyWith(
last_sync_at: null == last_sync_at ? _self.last_sync_at : last_sync_at // ignore: cast_nullable_to_non_nullable
as DateTime,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as SyncChanges,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncChangesCopyWith<$Res> get changes {
  
  return $SyncChangesCopyWith<$Res>(_self.changes, (value) {
    return _then(_self.copyWith(changes: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncRequest].
extension SyncRequestPatterns on SyncRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncRequest value)  $default,){
final _that = this;
switch (_that) {
case _SyncRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SyncRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime last_sync_at,  SyncChanges changes,  String deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncRequest() when $default != null:
return $default(_that.last_sync_at,_that.changes,_that.deviceId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime last_sync_at,  SyncChanges changes,  String deviceId)  $default,) {final _that = this;
switch (_that) {
case _SyncRequest():
return $default(_that.last_sync_at,_that.changes,_that.deviceId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime last_sync_at,  SyncChanges changes,  String deviceId)?  $default,) {final _that = this;
switch (_that) {
case _SyncRequest() when $default != null:
return $default(_that.last_sync_at,_that.changes,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncRequest implements SyncRequest {
  const _SyncRequest({required this.last_sync_at, required this.changes, required this.deviceId});
  factory _SyncRequest.fromJson(Map<String, dynamic> json) => _$SyncRequestFromJson(json);

@override final  DateTime last_sync_at;
@override final  SyncChanges changes;
@override final  String deviceId;

/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncRequestCopyWith<_SyncRequest> get copyWith => __$SyncRequestCopyWithImpl<_SyncRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncRequest&&(identical(other.last_sync_at, last_sync_at) || other.last_sync_at == last_sync_at)&&(identical(other.changes, changes) || other.changes == changes)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,last_sync_at,changes,deviceId);

@override
String toString() {
  return 'SyncRequest(last_sync_at: $last_sync_at, changes: $changes, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$SyncRequestCopyWith<$Res> implements $SyncRequestCopyWith<$Res> {
  factory _$SyncRequestCopyWith(_SyncRequest value, $Res Function(_SyncRequest) _then) = __$SyncRequestCopyWithImpl;
@override @useResult
$Res call({
 DateTime last_sync_at, SyncChanges changes, String deviceId
});


@override $SyncChangesCopyWith<$Res> get changes;

}
/// @nodoc
class __$SyncRequestCopyWithImpl<$Res>
    implements _$SyncRequestCopyWith<$Res> {
  __$SyncRequestCopyWithImpl(this._self, this._then);

  final _SyncRequest _self;
  final $Res Function(_SyncRequest) _then;

/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? last_sync_at = null,Object? changes = null,Object? deviceId = null,}) {
  return _then(_SyncRequest(
last_sync_at: null == last_sync_at ? _self.last_sync_at : last_sync_at // ignore: cast_nullable_to_non_nullable
as DateTime,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as SyncChanges,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncChangesCopyWith<$Res> get changes {
  
  return $SyncChangesCopyWith<$Res>(_self.changes, (value) {
    return _then(_self.copyWith(changes: value));
  });
}
}


/// @nodoc
mixin _$SyncResponse {

 DateTime get sync_at; SyncChanges get changes;
/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncResponseCopyWith<SyncResponse> get copyWith => _$SyncResponseCopyWithImpl<SyncResponse>(this as SyncResponse, _$identity);

  /// Serializes this SyncResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncResponse&&(identical(other.sync_at, sync_at) || other.sync_at == sync_at)&&(identical(other.changes, changes) || other.changes == changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sync_at,changes);

@override
String toString() {
  return 'SyncResponse(sync_at: $sync_at, changes: $changes)';
}


}

/// @nodoc
abstract mixin class $SyncResponseCopyWith<$Res>  {
  factory $SyncResponseCopyWith(SyncResponse value, $Res Function(SyncResponse) _then) = _$SyncResponseCopyWithImpl;
@useResult
$Res call({
 DateTime sync_at, SyncChanges changes
});


$SyncChangesCopyWith<$Res> get changes;

}
/// @nodoc
class _$SyncResponseCopyWithImpl<$Res>
    implements $SyncResponseCopyWith<$Res> {
  _$SyncResponseCopyWithImpl(this._self, this._then);

  final SyncResponse _self;
  final $Res Function(SyncResponse) _then;

/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sync_at = null,Object? changes = null,}) {
  return _then(_self.copyWith(
sync_at: null == sync_at ? _self.sync_at : sync_at // ignore: cast_nullable_to_non_nullable
as DateTime,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as SyncChanges,
  ));
}
/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncChangesCopyWith<$Res> get changes {
  
  return $SyncChangesCopyWith<$Res>(_self.changes, (value) {
    return _then(_self.copyWith(changes: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncResponse].
extension SyncResponsePatterns on SyncResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncResponse value)  $default,){
final _that = this;
switch (_that) {
case _SyncResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SyncResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime sync_at,  SyncChanges changes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncResponse() when $default != null:
return $default(_that.sync_at,_that.changes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime sync_at,  SyncChanges changes)  $default,) {final _that = this;
switch (_that) {
case _SyncResponse():
return $default(_that.sync_at,_that.changes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime sync_at,  SyncChanges changes)?  $default,) {final _that = this;
switch (_that) {
case _SyncResponse() when $default != null:
return $default(_that.sync_at,_that.changes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncResponse implements SyncResponse {
  const _SyncResponse({required this.sync_at, required this.changes});
  factory _SyncResponse.fromJson(Map<String, dynamic> json) => _$SyncResponseFromJson(json);

@override final  DateTime sync_at;
@override final  SyncChanges changes;

/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncResponseCopyWith<_SyncResponse> get copyWith => __$SyncResponseCopyWithImpl<_SyncResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncResponse&&(identical(other.sync_at, sync_at) || other.sync_at == sync_at)&&(identical(other.changes, changes) || other.changes == changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sync_at,changes);

@override
String toString() {
  return 'SyncResponse(sync_at: $sync_at, changes: $changes)';
}


}

/// @nodoc
abstract mixin class _$SyncResponseCopyWith<$Res> implements $SyncResponseCopyWith<$Res> {
  factory _$SyncResponseCopyWith(_SyncResponse value, $Res Function(_SyncResponse) _then) = __$SyncResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime sync_at, SyncChanges changes
});


@override $SyncChangesCopyWith<$Res> get changes;

}
/// @nodoc
class __$SyncResponseCopyWithImpl<$Res>
    implements _$SyncResponseCopyWith<$Res> {
  __$SyncResponseCopyWithImpl(this._self, this._then);

  final _SyncResponse _self;
  final $Res Function(_SyncResponse) _then;

/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sync_at = null,Object? changes = null,}) {
  return _then(_SyncResponse(
sync_at: null == sync_at ? _self.sync_at : sync_at // ignore: cast_nullable_to_non_nullable
as DateTime,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as SyncChanges,
  ));
}

/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncChangesCopyWith<$Res> get changes {
  
  return $SyncChangesCopyWith<$Res>(_self.changes, (value) {
    return _then(_self.copyWith(changes: value));
  });
}
}

// dart format on
