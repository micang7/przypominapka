import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:app/features/auth/presentation/screens/login_screen.dart';
import 'package:app/features/auth/presentation/screens/register_screen.dart';
import 'package:app/features/tasks/presentation/screens/main_screen.dart';
import 'package:app/features/tasks/presentation/screens/map_picker_screen.dart';

part 'app_router.g.dart';

String? getRouterRedirect(AuthState authState, String location) {
  if (authState.isInitializing) return '/splash';
  
  final isAuthenticated = authState.isAuthenticated;
  final isLoggingIn = location == '/login';
  final isRegistering = location == '/register';
  final isSplash = location == '/splash';

  if (!isAuthenticated && !isLoggingIn && !isRegistering && !isSplash) {
    return '/login';
  }

  if (isAuthenticated && (isLoggingIn || isRegistering || isSplash)) {
    return '/home';
  }

  return null;
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: authState.isInitializing ? '/splash' : (authState.isAuthenticated ? '/home' : '/login'),
    redirect: (context, state) => getRouterRedirect(authState, state.matchedLocation),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/map-picker',
        builder: (context, state) => const MapPickerScreen(),
      ),
    ],
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
