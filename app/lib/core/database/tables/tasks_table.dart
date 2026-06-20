import 'package:drift/drift.dart';

@DataClassName('TaskEntry')
class Tasks extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()(); // one_time, recurrent
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  DateTimeColumn get timeTriggerAt => dateTime().nullable()();
  RealColumn get geoTriggerLatitude => real().nullable()();
  RealColumn get geoTriggerLongitude => real().nullable()();
  IntColumn get geoTriggerRadius => integer().nullable()();

  IntColumn get version => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // Pola pomocnicze dla synchronizacji
  BoolColumn get isPendingSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AppMetadataEntry')
class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
