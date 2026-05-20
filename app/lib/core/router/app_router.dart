import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';

part 'app_router.g.dart';

// Globalny provider dla naszego routera
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '`/login`', // Zaczynamy od logowania
    routes: [
      GoRoute(
        path: '`/login`',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '`/register`',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '`/home`', // Ścieżka home zmieniona na /home
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