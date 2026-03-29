import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';

/// Provides AuthRepository instance.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Auth state notifier.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState());

  /// Extract a clean, user-friendly error message from any exception.
  String _friendlyError(Object e) {
    if (e is ApiException) {
      // Server returned a structured error (e.g. 'Invalid password')
      return e.message;
    }
    if (e is SocketException) {
      return 'No internet connection. Please check your network.';
    }
    final msg = e.toString();
    // Strip 'Exception: ' prefix if present
    if (msg.startsWith('Exception: ')) {
      return msg.substring(11);
    }
    return 'Something went wrong. Please try again.';
  }

  /// Register with phone + password + role.
  Future<bool> register(
    String phone,
    String password, {
    String? name,
    String role = 'CUSTOMER',
  }) async {
    state = state.copyWith(status: AuthStatus.loading, phoneNumber: phone);

    try {
      final data = await _repo.register(
        phone: phone,
        password: password,
        name: name,
        role: role,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: AppUser.fromJson(data['user']),
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  /// Login with phone + password.
  Future<bool> login(String phone, String password) async {
    state = state.copyWith(status: AuthStatus.loading, phoneNumber: phone);

    try {
      final data = await _repo.login(phone: phone, password: password);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: AppUser.fromJson(data['user']),
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  /// Check auth status from stored token.
  Future<bool> checkAuthStatus() async {
    try {
      final user = await _repo.getCurrentUser();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        return true;
      }
    } catch (_) {}
    state = state.copyWith(status: AuthStatus.unauthenticated);
    return false;
  }

  /// Sign out.
  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
