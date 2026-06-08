import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/models/task_models.dart' as api;
import 'package:app/core/services/device_service.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';

part 'fcm_service.g.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  if (message.data['type'] == 'SYNC_REQUEST') {
    final container = ProviderContainer();
    try {
      await container.read(taskRepositoryProvider).syncTasks();
    } finally {
      container.dispose();
    }
  }
}

class FCMService {
  final Ref ref;

  FCMService(this.ref);

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
    } catch (_) {}

    // Prośba o uprawnienia (ważne szczególnie na iOS)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Obsługa włączonej aplikacji (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'SYNC_REQUEST') {
        ref.read(taskRepositoryProvider).syncTasks();
      }
    });

    // Obsługa kliknięcia w powiadomienie
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'SYNC_REQUEST') {
        ref.read(taskRepositoryProvider).syncTasks();
      }
    });

    // Odświeżanie tokenu
    FirebaseMessaging.instance.onTokenRefresh.listen(_uploadToken);
    
    // Pierwszy upload
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _uploadToken(token);
    }
  }

  Future<void> _uploadToken(String token) async {
    final deviceId = await ref.read(deviceServiceProvider).getDeviceId();
    final accessToken = await ref.read(authLocalDatasourceProvider).getAccessToken();

    if (accessToken != null) {
      try {
        await ref.read(apiClientProvider).sessions.updateFcmToken(
          api.SessionsUpdateFcmTokenDto(
            deviceId: deviceId,
            fcmToken: token,
          ),
        );
      } catch (e) {
        // Cichy błąd
      }
    }
  }
}

@Riverpod(keepAlive: true)
FCMService fcmService(Ref ref) => FCMService(ref);
