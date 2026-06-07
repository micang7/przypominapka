import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_service.g.dart';

class PermissionsService {
  Future<void> requestInitialPermissions() async {
    await Permission.notification.request();
    final status = await Permission.location.request();
    if (status.isGranted) {
      await Permission.locationAlways.request();
    }
    await Permission.scheduleExactAlarm.request();
  }
}

@riverpod
PermissionsService permissionsService(Ref ref) => PermissionsService();
