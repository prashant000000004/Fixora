import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/service_repository.dart';
import '../domain/service_models.dart';

/// Service repository provider.
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

/// All categories provider (async — fetches from backend).
final categoriesProvider = FutureProvider<List<ServiceCategory>>((ref) async {
  return ref.watch(serviceRepositoryProvider).getCategories();
});

/// Sub-services for a category (async).
final subServicesProvider = FutureProvider.family<List<SubService>, String>((
  ref,
  categoryId,
) async {
  return ref.watch(serviceRepositoryProvider).getSubServices(categoryId);
});

/// Providers for a service, with optional sort (async).
final providersProvider = FutureProvider.family<List<ServiceProvider>, String?>(
  (ref, sortBy) async {
    return ref.watch(serviceRepositoryProvider).getProviders(sortBy: sortBy);
  },
);

/// Single provider by ID (async).
final providerByIdProvider = FutureProvider.family<ServiceProvider?, String>((
  ref,
  id,
) async {
  return ref.watch(serviceRepositoryProvider).getProviderById(id);
});

/// Search suggestions provider (client-side, stays synchronous).
final searchSuggestionsProvider =
    StateProvider.family<List<Map<String, String>>, String>((ref, query) {
      if (query.isEmpty) return [];
      return ref.watch(serviceRepositoryProvider).getSearchSuggestions(query);
    });

/// Search results provider (async — calls backend).
final searchResultsProvider = FutureProvider.family<List<SubService>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  return ref.watch(serviceRepositoryProvider).searchServices(query);
});
