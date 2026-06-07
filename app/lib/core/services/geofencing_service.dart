import 'package:native_geofence/native_geofence.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'geofencing_service.g.dart';

@pragma('vm:entry-point')
Future<void> geofenceCallback(GeofenceCallbackParams params) async {
  if (params.event == GeofenceEvent.enter) {
    final notifications = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@android:drawable/ic_dialog_info');
    await notifications.initialize(settings: const InitializationSettings(android: androidSettings));

    for (final geofence in params.geofences) {
      final parts = geofence.id.split('|');
      final taskId = parts[0];
      final taskTitle = parts.length > 1 ? parts[1] : 'Zadanie regionalne';

      await notifications.show(
        id: taskId.hashCode.abs() % 2147483647,
        title: 'Dotarłeś na miejsce! 📍',
        body: 'Zadanie: ' + taskTitle,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'geofence_channel',
            'Powiadomienia regionalne',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }
}

class GeofencingService {
  Future<void> init() async {
    await NativeGeofenceManager.instance.initialize();
  }

  Future<void> registerGeofence({
    required String id,
    required String title,
    required double lat,
    required double lng,
    required double radius,
  }) async {
    final geofence = Geofence(
      id: id + '|' + title,
      location: Location(latitude: lat, longitude: lng),
      radiusMeters: radius,
      triggers: {GeofenceEvent.enter},
      iosSettings: const IosGeofenceSettings(initialTrigger: true),
      androidSettings: const AndroidGeofenceSettings(
        initialTriggers: {GeofenceEvent.enter},
        // Ustawienie responsywności na 0 sugeruje systemowi najszybszą możliwą reakcję
        notificationResponsiveness: Duration.zero,
      ),
    );

    await NativeGeofenceManager.instance.createGeofence(geofence, geofenceCallback);
  }

  Future<void> removeGeofence(String id, String title) async {
    await NativeGeofenceManager.instance.removeGeofenceById(id + '|' + title);
  }
}

@Riverpod(keepAlive: true)
GeofencingService geofencingService(Ref ref) => GeofencingService();
