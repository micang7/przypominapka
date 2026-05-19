import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// Globalny provider dla naszego routera
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    // TODO: Tutaj w przyszłości dodamy logikę przekierowań
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Przypominapka')),
          body: const Center(
            child: Text('Witaj w systemie przypomnień!'),
          ),
        ),
      ),
    ],
  );
}