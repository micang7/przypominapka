import 'dart:developer' as dev;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      // Zwraca obiekt TimezoneInfo, tak jak w Twoim pierwotnym kodzie
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final String timezoneName = timezoneInfo.identifier;
      
      tz.setLocalLocation(tz.getLocation(timezoneName));
      dev.log('✅ Strefa czasowa pomyślnie ustawiona na: $timezoneName', name: 'NotificationService');
    } catch (e) {
      // TERAZ ZOBACZYMY PRAWDZIWY POWÓD BŁĘDU
      dev.log('❌ BŁĄD INICJALIZACJI STREFY CZASOWEJ: $e', name: 'NotificationService');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _notifications.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    const channel = AndroidNotificationChannel(
      'task_reminders',
      'Przypomnienia',
      importance: Importance.max,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // DODAJ TE PRINTY:
    dev.log('--- PRÓBA ZAPLANOWANIA POWIADOMIENIA ---', name: 'NotificationService');
    dev.log('ID: $id', name: 'NotificationService');
    dev.log('Data przekazana (Raw): $scheduledDate (isUtc: ${scheduledDate.isUtc})', name: 'NotificationService');
    dev.log('Czas teraz (Local): ${DateTime.now()}', name: 'NotificationService');

    if (scheduledDate.isBefore(DateTime.now())) {
      dev.log('❌ ANULOWANO: Data jest w przeszłości!', name: 'NotificationService');
      return;
    }

    dev.log('🚀 Przekazuję do zonedSchedule...', name: 'NotificationService');
    final localLocation = tz.local;
    
    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, localLocation),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Przypomnienia',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    dev.log('✅ Powiadomienie zaplanowane pomyślnie w systemie!', name: 'NotificationService');
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();
