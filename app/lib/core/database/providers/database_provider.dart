import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true) // <-- Tutaj brakowało @Riverpod
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  
  // Upewniamy się, że połączenie z bazą zostanie zamknięte, gdy provider zostanie zniszczony
  ref.onDispose(() => database.close());
  
  return database;
}