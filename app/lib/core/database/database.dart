import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tasks_table.dart';

// Ten plik wygeneruje build_runner
part 'database.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  
  int get schemaVersion => 1;

  // Przykładowe metody dostępowe - w przyszłości można je wydzielić do klas DAO
  Future<List<Task>> getAllTasks() => select(tasks).get();
  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);
  Future<bool> updateTask(Task task) => update(tasks).replace(task);
  Future<int> deleteTask(Task task) => delete(tasks).delete(task);
}

LazyDatabase _openConnection() {
  // Funkcja szukająca odpowiedniego miejsca na dysku telefonu dla pliku SQLite
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}