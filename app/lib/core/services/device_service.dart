import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:app/core/database/database.dart';

part 'device_service.g.dart';

class DeviceService {
  final AppDatabase _db;

  DeviceService(this._db);

  Future<String> getDeviceId() async {
    final entry = await (_db.select(_db.appMetadata)..where((t) => t.key.equals('device_id'))).getSingleOrNull();
    
    if (entry != null) {
      return entry.value;
    }

    final newId = const Uuid().v4();
    await _db.into(_db.appMetadata).insert(AppMetadataEntry(key: 'device_id', value: newId));
    return newId;
  }
}

@Riverpod(keepAlive: true)
DeviceService deviceService(Ref ref) {
  return DeviceService(ref.watch(appDatabaseProvider));
}
