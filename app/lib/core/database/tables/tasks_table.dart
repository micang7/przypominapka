// TODO: Uncomment when drift is properly set up
// import 'package:drift/drift.dart';
// 
// class Tasks extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text().withLength(min: 1, max: 255)();
//   TextColumn get description => text().nullable()();
//   BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
//   
//   DateTimeColumn get dueDate => dateTime().nullable()();
//   RealColumn get latitude => real().nullable()();
//   RealColumn get longitude => real().nullable()();
//   RealColumn get radius => real().nullable()();
//   
//   BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
//   DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
// }