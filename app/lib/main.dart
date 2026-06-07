import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:app/core/services/geofencing_service.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();
  
  // Inicjalizacja bez blokowania startu UI
  unawaited(container.read(notificationServiceProvider).init());
  unawaited(container.read(geofencingServiceProvider).init());

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

// Pomocnicza funkcja dla unawaited
void unawaited(Future<void> future) {}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Przypominapka',
      routerConfig: goRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
