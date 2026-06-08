import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_service.g.dart';

class PermissionsService {
  Future<void> requestInitialPermissions() async {
    // 1. Powiadomienia
    await Permission.notification.request();

    // 2. Lokalizacja (Najpierw podstawowa, potem w tle)
    // Na Androidzie 10+ wymagane jest najpierw uzyskanie zgody na "podczas używania",
    // a dopiero potem można prosić o "zawsze".
    final status = await Permission.location.request();
    if (status.isGranted) {
      await Permission.locationAlways.request();
    }

    // 3. Dokładne alarmy (dla zadań czasowych)
    await Permission.scheduleExactAlarm.request();

    // 4. Optymalizacja baterii (dla Strażnika Lokalizacji)
    await Permission.ignoreBatteryOptimizations.request();
  }
}

@riverpod
PermissionsService permissionsService(Ref ref) => PermissionsService();
