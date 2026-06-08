import 'dart:io';
import 'dart:developer' as dev;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// --- DODANE IMPORTY ---
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';


import 'tables/tasks_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Tasks, AppMetadata])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          dev.log('Database: onCreate() called');
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          dev.log('Database: onUpgrade() from $from to $to');
          await m.deleteTable('tasks');
          await m.deleteTable('app_metadata');
          await m.createAll();
        },
        beforeOpen: (details) async {
          dev.log('Database: beforeOpen() version: ${details.versionNow}');
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    dev.log('Database: Opening connection at path: ${file.path}');
    
    if (await file.exists()) {
      dev.log('Database: DB file exists. Size: ${await file.length()} bytes');
    } else {
      dev.log('Database: DB file does not exist, creating new');
    }

    // Wymuszamy na sqlite3 użycie odpowiedniego folderu tymczasowego.
    // Domyślny /tmp na Androidzie jest niedostępny przez zabezpieczenia systemu (sandboxing).
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    // Zamiast zwykłego NativeDatabase, zalecane jest użycie createInBackground,
    // co zapobiega blokowaniu głównego wątku (UI) przy cięższych operacjach.
    return NativeDatabase.createInBackground(file);
  });
}

@riverpod
AppDatabase appDatabase(Ref ref) {
  dev.log('Database Provider: Initializing AppDatabase');
  final db = AppDatabase();
  ref.onDispose(() {
    dev.log('Database Provider: Disposing AppDatabase');
    db.close();
  });
  return db;
}