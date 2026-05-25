import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/auth_repository_contract.dart';
import 'auth_providers.dart';

// State class to handle loading, error, and data states
class AuthState {
  final AuthResponse? authResponse;
  final bool isLoading;
  final String? error;

  AuthState({
    this.authResponse,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AuthResponse? authResponse,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      authResponse: authResponse ?? this.authResponse,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => authResponse != null;
}

class AuthNotifier extends Notifier<AuthState> {
  late IAuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return AuthState();
  }

  Future<void> register({
    required String login,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.register(
        login: login,
        password: password,
        confirmPassword: confirmPassword,
      );

      state = state.copyWith(
        authResponse: result,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> login({
    required String login,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.login(
        login: login,
        password: password,
      );

      state = state.copyWith(
        authResponse: result,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.logout();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> checkAuthentication() async {
    try {
      final isAuth = await _authRepository.isAuthenticated();
      // TODO: Fetch current user data from backend if needed
      if (!isAuth) {
        state = AuthState();
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Riverpod provider for auth state using Notifier
final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
