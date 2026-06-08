import 'dart:async';
import 'package:native_geofence/native_geofence.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

part 'geofencing_service.g.dart';

@pragma('vm:entry-point')
Future<void> geofenceCallback(GeofenceCallbackParams params) async {
  if (params.event == GeofenceEvent.enter) {
    _showNotification(params.geofences.first.id);
  }
}

Future<void> _showNotification(String geofenceId) async {
  final notifications = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@android:drawable/ic_dialog_info');
  await notifications.initialize(settings: const InitializationSettings(android: androidSettings));

  final parts = geofenceId.split('|');
  final taskId = parts[0];
  final taskTitle = parts.length > 1 ? parts[1] : 'Zadanie regionalne';

  await notifications.show(
    id: taskId.hashCode.abs() % 2147483647,
    title: 'Dotarłeś na miejsce! 📍',
    body: 'Zadanie: $taskTitle',
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'geofence_channel',
        'Powiadomienia regionalne',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
      ),
    ),
  );
}

class GeofenceData {
  final String id;
  final String title;
  final double lat;
  final double lng;
  final double radius;
  bool isInside;

  GeofenceData({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
    required this.radius,
    this.isInside = false,
  });
}

class GeofencingService {
  final Map<String, GeofenceData> _activeGeofences = {};
  StreamSubscription<Position>? _positionSubscription;

  Future<void> init() async {
    await NativeGeofenceManager.instance.initialize();
  }

  void _startActiveMonitoring() {
    if (_positionSubscription != null) return;

    try {
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5, // Częsta aktualizacja co 5 metrów
          intervalDuration: const Duration(seconds: 5), // I co 5 sekund
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "Monitorowanie zadań regionalnych w czasie rzeczywistym",
            notificationTitle: "Przypominapka - Strażnik Lokalizacji",
            enableWakeLock: true,
          ),
        ),
      ).listen(
        (Position position) {
          _checkGeofences(position);
        },
        onError: (error) {
          _positionSubscription?.cancel();
          _positionSubscription = null;
        },
      );
    } catch (e) {
      // Cichy błąd, jeśli np. brak uprawnień w momencie startu
      _positionSubscription = null;
    }
  }

  void _checkGeofences(Position currentPos) {
    for (final geo in _activeGeofences.values) {
      final distance = Geolocator.distanceBetween(
        currentPos.latitude,
        currentPos.longitude,
        geo.lat,
        geo.lng,
      );

      if (distance <= geo.radius) {
        if (!geo.isInside) {
          // Właśnie weszliśmy w strefę!
          geo.isInside = true;
          _showNotification('${geo.id}|${geo.title}');
        }
      } else {
        geo.isInside = false;
      }
    }
  }

  Future<void> registerGeofence({
    required String id,
    required String title,
    required double lat,
    required double lng,
    required double radius,
  }) async {
    // 1. Rejestracja natywna (jako backup)
    final geofence = Geofence(
      id: '$id|$title',
      location: Location(latitude: lat, longitude: lng),
      radiusMeters: radius,
      triggers: {GeofenceEvent.enter},
      iosSettings: const IosGeofenceSettings(initialTrigger: true),
      androidSettings: const AndroidGeofenceSettings(
        initialTriggers: {GeofenceEvent.enter},
        notificationResponsiveness: Duration.zero,
      ),
    );
    await NativeGeofenceManager.instance.createGeofence(geofence, geofenceCallback);

    // 2. Rejestracja w aktywnym monitoringu
    _activeGeofences[id] = GeofenceData(
      id: id,
      title: title,
      lat: lat,
      lng: lng,
      radius: radius,
    );

    _startActiveMonitoring();
  }

  Future<void> removeGeofence(String id, String title) async {
    await NativeGeofenceManager.instance.removeGeofenceById('$id|$title');
    _activeGeofences.remove(id);
    
    if (_activeGeofences.isEmpty) {
      _positionSubscription?.cancel();
      _positionSubscription = null;
    }
  }
}

@Riverpod(keepAlive: true)
GeofencingService geofencingService(Ref ref) => GeofencingService();
