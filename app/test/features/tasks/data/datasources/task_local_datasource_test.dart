import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:app/core/database/database.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNotNull;

void main() {
  late AppDatabase db;
  late TaskLocalDatasource datasource;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    datasource = TaskLocalDatasource(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('upsertTask should save task to database', () async {
    final task = TaskEntry(
      id: '1',
      title: 'Database Task',
      type: 'one_time',
      completed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPendingSync: true,
    );

    await datasource.upsertTask(task);

    final saved = await datasource.getTaskById('1');
    expect(saved, isNotNull);
    expect(saved!.title, 'Database Task');
  });

  test('getAllTasks should return non-deleted tasks', () async {
    final task1 = TaskEntry(
      id: '1',
      title: 'T1',
      type: 'one_time',
      completed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPendingSync: false,
    );
    final task2 = TaskEntry(
      id: '2',
      title: 'T2',
      type: 'one_time',
      completed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPendingSync: false,
      deletedAt: DateTime.now(),
    );

    await datasource.upsertTask(task1);
    await datasource.upsertTask(task2);

    final tasks = await datasource.getAllTasks();
    expect(tasks.length, 1);
    expect(tasks.first.id, '1');
  });
}
