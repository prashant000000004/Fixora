import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';

/// Profile repository — communicates with Spring Boot backend.
class ProfileRepository {
  /// Save/update user profile.
  Future<void> saveProfile({
    required String userId,
    required String name,
    String? email,
    String? homeAddress,
    String? workAddress,
    String? photoUrl,
  }) async {
    try {
      final addresses = <Map<String, dynamic>>[];
      if (homeAddress != null && homeAddress.isNotEmpty) {
        addresses.add({'label': 'Home', 'address': homeAddress});
      }
      if (workAddress != null && workAddress.isNotEmpty) {
        addresses.add({'label': 'Work', 'address': workAddress});
      }

      final response = await ApiClient.put(
        '/users/me',
        body: {
          'name': name,
          if (email != null) 'email': email,
          if (photoUrl != null) 'photoUrl': photoUrl,
          'savedAddresses': addresses,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save profile');
      }
    } catch (e) {
      debugPrint('Profile save failed: $e');
      rethrow;
    }
  }

  /// Get user profile.
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await ApiClient.get('/users/me');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Get profile failed: $e');
      return null;
    }
  }

  /// Update user profile.
  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      await ApiClient.put('/users/me', body: data);
    } catch (e) {
      debugPrint('Profile update failed: $e');
    }
  }
}
