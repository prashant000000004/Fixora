import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../domain/auth_state.dart';

/// Auth repository — communicates with Spring Boot backend.
/// ApiClient already throws ApiException on non-2xx responses,
/// so this repository only handles successful response decoding.
class AuthRepository {
  /// Register with phone + password + role.
  Future<Map<String, dynamic>> register({
    required String phone,
    required String password,
    String? name,
    String role = 'CUSTOMER',
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/register',
        body: {
          'phone': phone,
          'password': password,
          if (name != null) 'name': name,
          'role': role,
        },
      );

      // ApiClient.post() throws ApiException on non-2xx.
      // If we reach here, the request succeeded.
      final data = jsonDecode(response.body);
      await ApiClient.saveToken(data['token']);
      return data;
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow; // ApiException propagates with its message intact
    }
  }

  /// Login with phone + password.
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/login',
        body: {'phone': phone, 'password': password},
      );

      // ApiClient.post() throws ApiException on non-2xx.
      // If we reach here, the request succeeded.
      final data = jsonDecode(response.body);
      await ApiClient.saveToken(data['token']);
      return data;
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow; // ApiException propagates with its message intact
    }
  }

  /// Google Sign-In via backend.
  Future<Map<String, dynamic>> signInWithGoogle(String idToken) async {
    try {
      final response = await ApiClient.post(
        '/auth/google',
        body: {'idToken': idToken},
      );

      // ApiClient.post() throws ApiException on non-2xx.
      // If we reach here, the request succeeded.
      final data = jsonDecode(response.body);
      await ApiClient.saveToken(data['token']);
      return data;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      rethrow; // ApiException propagates with its message intact
    }
  }

  /// Get current user profile.
  Future<AppUser?> getCurrentUser() async {
    try {
      final isLoggedIn = await ApiClient.isLoggedIn();
      if (!isLoggedIn) return null;

      final response = await ApiClient.get('/users/me');
      return AppUser.fromJson(jsonDecode(response.body));
    } catch (e) {
      debugPrint('Get current user failed: $e');
      return null;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    await ApiClient.clearToken();
  }
}
