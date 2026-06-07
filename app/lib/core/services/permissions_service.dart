import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_service.g.dart';

class PermissionsService {
  Future<bool> requestInitialPermissions() async {
    // 1. Prośba o powiadomienia
    await Permission.notification.request();

    // 2. Prośba o lokalizację (podstawowa - w trakcie używania)
    final status = await Permission.location.request();

    // Jeśli użytkownik zaakceptował podstawową lokalizację, 
    // prosimy o lokalizację w tle (wymagane do geofencingu)
    if (status.isGranted) {
      await Permission.locationAlways.request();
    }

    return status.isGranted;
  }

  Future<bool> checkLocationPermission() async {
    return await Permission.location.isGranted;
  }
}

@riverpod
PermissionsService permissionsService(Ref ref) {
  return PermissionsService();
}
