import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/auth/presentation/providers/auth_state_provider.dart';

void main() {
  group('AppRouter Redirect Logic', () {
    test('Redirects to /login if not authenticated and trying to access root', () {
      final state = const AuthState(isAuthenticated: false, isInitializing: false);
      final redirect = getRouterRedirect(state, '/home');
      expect(redirect, '/login');
    });

    test('Does not redirect if already on /login and not authenticated', () {
      final state = const AuthState(isAuthenticated: false, isInitializing: false);
      final redirect = getRouterRedirect(state, '/login');
      expect(redirect, null);
    });

    test('Redirects to /home if authenticated and trying to access /login', () {
      final state = const AuthState(isAuthenticated: true, isInitializing: false);
      final redirect = getRouterRedirect(state, '/login');
      expect(redirect, '/home');
    });

    test('Does not redirect if authenticated and accessing /home', () {
      final state = const AuthState(isAuthenticated: true, isInitializing: false);
      final redirect = getRouterRedirect(state, '/home');
      expect(redirect, null);
    });

    test('Returns /splash if initializing', () {
      final state = const AuthState(isAuthenticated: false, isInitializing: true);
      final redirect = getRouterRedirect(state, '/login');
      expect(redirect, '/splash');
    });
  });
}
