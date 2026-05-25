import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';

part 'auth_state_provider.freezed.dart';
part 'auth_state_provider.g.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(true) bool isInitializing,
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    String? error,
  }) = _AuthState;
}

@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AuthState build() {
    _init();
    return const AuthState();
  }

  Future<void> _init() async {
    final success = await ref.read(authRepositoryProvider).tryAutoLogin();
    state = state.copyWith(
      isInitializing: false,
      isAuthenticated: success,
    );
  }

  Future<void> login(String login, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(authRepositoryProvider).login(login, password);
      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String login, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(authRepositoryProvider).register(login, password);
      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState(isInitializing: false, isAuthenticated: false);
  }
}
