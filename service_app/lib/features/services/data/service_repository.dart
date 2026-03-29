import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../domain/service_models.dart';

/// Service repository — communicates with the Spring Boot backend.
class ServiceRepository {
  /// Get all service categories from backend.
  Future<List<ServiceCategory>> getCategories() async {
    try {
      final response = await ApiClient.get('/services/categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ServiceCategory.fromJson(json)).toList();
      }
      throw Exception('Failed to load categories: ${response.statusCode}');
    } catch (e) {
      debugPrint('getCategories error: $e');
      rethrow;
    }
  }

  /// Get sub-services for a category.
  Future<List<SubService>> getSubServices(String categoryId) async {
    try {
      final response = await ApiClient.get(
        '/services/categories/$categoryId/sub-services',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SubService.fromJson(json)).toList();
      }
      throw Exception('Failed to load sub-services: ${response.statusCode}');
    } catch (e) {
      debugPrint('getSubServices error: $e');
      rethrow;
    }
  }

  /// Get providers with optional sort.
  Future<List<ServiceProvider>> getProviders({String? sortBy}) async {
    try {
      final query = sortBy != null ? '?sortBy=$sortBy' : '';
      final response = await ApiClient.get('/services/providers$query');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ServiceProvider.fromJson(json)).toList();
      }
      throw Exception('Failed to load providers: ${response.statusCode}');
    } catch (e) {
      debugPrint('getProviders error: $e');
      rethrow;
    }
  }

  /// Get provider by ID.
  Future<ServiceProvider?> getProviderById(String id) async {
    try {
      final response = await ApiClient.get('/services/providers/$id');
      if (response.statusCode == 200) {
        return ServiceProvider.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('getProviderById error: $e');
      return null;
    }
  }

  /// Search services by query.
  Future<List<SubService>> searchServices(String query) async {
    try {
      final response = await ApiClient.get(
        '/services/search?q=${Uri.encodeComponent(query)}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SubService.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('searchServices error: $e');
      return [];
    }
  }

  /// Search suggestions — client-side mapping of common queries to categories.
  List<Map<String, String>> getSearchSuggestions(String query) {
    final lower = query.toLowerCase();
    final suggestions = <Map<String, String>>[];

    for (final mapping in _searchMappings) {
      if (mapping['query']!.toLowerCase().contains(lower) ||
          lower.contains(mapping['query']!.toLowerCase())) {
        suggestions.add(mapping);
      }
    }

    return suggestions.take(6).toList();
  }
}

// ─── Client-side search mappings ────────────────────────────────
const _searchMappings = [
  {
    'query': 'fan not working',
    'category': 'Electrician',
    'categoryId': 'electrical',
  },
  {
    'query': 'fan installation',
    'category': 'Electrician',
    'categoryId': 'electrical',
  },
  {'query': 'leaking pipe', 'category': 'Plumber', 'categoryId': 'plumbing'},
  {'query': 'tap repair', 'category': 'Plumber', 'categoryId': 'plumbing'},
  {'query': 'blocked drain', 'category': 'Plumber', 'categoryId': 'plumbing'},
  {
    'query': 'broken switch',
    'category': 'Electrician',
    'categoryId': 'electrical',
  },
  {
    'query': 'ac not cooling',
    'category': 'AC Repair',
    'categoryId': 'ac_repair',
  },
  {'query': 'ac service', 'category': 'AC Repair', 'categoryId': 'ac_repair'},
  {'query': 'deep cleaning', 'category': 'Cleaning', 'categoryId': 'cleaning'},
  {'query': 'sofa cleaning', 'category': 'Cleaning', 'categoryId': 'cleaning'},
  {'query': 'paint room', 'category': 'Painting', 'categoryId': 'painting'},
  {'query': 'door repair', 'category': 'Carpentry', 'categoryId': 'carpentry'},
  {
    'query': 'furniture assembly',
    'category': 'Carpentry',
    'categoryId': 'carpentry',
  },
  {
    'query': 'cockroach',
    'category': 'Pest Control',
    'categoryId': 'pest_control',
  },
  {
    'query': 'termite',
    'category': 'Pest Control',
    'categoryId': 'pest_control',
  },
];
