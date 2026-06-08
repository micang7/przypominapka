import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/services/device_service.dart';
import 'package:app/core/database/database.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNotNull;

void main() {
  late AppDatabase db;
  late DeviceService service;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    service = DeviceService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('getDeviceId should generate and save a new ID if none exists', () async {
    final id1 = await service.getDeviceId();
    expect(id1, isNotNull);
    expect(id1.length, 36); // UUID length

    final id2 = await service.getDeviceId();
    expect(id2, id1); // Should be the same
  });
}
