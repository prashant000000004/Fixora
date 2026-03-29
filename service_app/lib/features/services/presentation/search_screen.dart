import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../data/service_repository.dart';
import '../domain/service_models.dart';
import 'category_detail_screen.dart';

/// Search screen with auto-suggestions and results.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final _repo = ServiceRepository();
  List<Map<String, String>> _suggestions = [];
  List<SubService> _results = [];
  bool _hasSearched = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _results = [];
        _hasSearched = false;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _suggestions = _repo.getSearchSuggestions(query);
      _isSearching = true;
      _hasSearched = true;
    });

    try {
      final results = await _repo.searchServices(query);
      if (mounted) {
        setState(() {
          _results = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _navigateToCategory(String categoryId, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CategoryDetailScreen(
              categoryId: categoryId,
              categoryName: categoryName,
              categoryColor: _getCategoryColor(categoryId),
            ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Search Bar ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _onSearchChanged,
                        style: AppTypography.bodyLarge.copyWith(
                          color:
                              isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search "fan not working"...',
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color:
                                isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon:
                              _searchController.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                      color:
                                          isDark
                                              ? AppColors.textTertiaryDark
                                              : AppColors.textTertiaryLight,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                  )
                                  : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Content ─────────────────────────────
            Expanded(
              child:
                  !_hasSearched
                      ? _buildPopularSearches(isDark)
                      : _isSearching && _results.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : _suggestions.isNotEmpty || _results.isNotEmpty
                      ? _buildSearchResults(isDark)
                      : _buildNoResults(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSearches(bool isDark) {
    final popular = [
      {
        'query': 'AC Service',
        'icon': Icons.ac_unit_rounded,
        'color': const Color(0xFF2563EB),
      },
      {
        'query': 'Full Home Cleaning',
        'icon': Icons.cleaning_services_rounded,
        'color': const Color(0xFF059669),
      },
      {
        'query': 'Electrician',
        'icon': Icons.electrical_services_rounded,
        'color': const Color(0xFFD97706),
      },
      {
        'query': 'Plumber',
        'icon': Icons.plumbing_rounded,
        'color': const Color(0xFF0891B2),
      },
      {
        'query': 'Carpenter',
        'icon': Icons.carpenter_rounded,
        'color': const Color(0xFFB45309),
      },
      {
        'query': 'Painting',
        'icon': Icons.format_paint_rounded,
        'color': const Color(0xFF7C3AED),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Text(
            'Popular Searches',
            style: AppTypography.headlineSmall.copyWith(
              color:
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                popular
                    .map(
                      (item) => GestureDetector(
                        onTap: () {
                          _searchController.text = item['query'] as String;
                          _onSearchChanged(item['query'] as String);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? AppColors.cardDark
                                    : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isDark
                                      ? AppColors.dividerDark
                                      : AppColors.dividerLight,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                size: 18,
                                color: item['color'] as Color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item['query'] as String,
                                style: AppTypography.labelLarge.copyWith(
                                  color:
                                      isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Suggestions
        if (_suggestions.isNotEmpty) ...[
          Text(
            'Suggestions',
            style: AppTypography.labelLarge.copyWith(
              color:
                  isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
            ),
          ),
          const SizedBox(height: 8),
          ..._suggestions.map(
            (s) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                s['query'] ?? '',
                style: AppTypography.titleMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
              ),
              subtitle: Text(
                s['category'] ?? '',
                style: AppTypography.labelSmall.copyWith(
                  color:
                      isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                ),
              ),
              trailing: const Icon(
                Icons.north_west_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              onTap:
                  () => _navigateToCategory(
                    s['categoryId'] ?? '',
                    s['category'] ?? '',
                  ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Matching services
        if (_results.isNotEmpty) ...[
          Text(
            'Services',
            style: AppTypography.labelLarge.copyWith(
              color:
                  isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
            ),
          ),
          const SizedBox(height: 8),
          ..._results.map(
            (sub) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.name,
                          style: AppTypography.titleMedium.copyWith(
                            color:
                                isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sub.description,
                          style: AppTypography.bodySmall.copyWith(
                            color:
                                isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${sub.minPrice} - ₹${sub.maxPrice}',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNoResults(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color:
                isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: AppTypography.headlineSmall.copyWith(
              color:
                  isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: AppTypography.bodyMedium.copyWith(
              color:
                  isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'electrical':
        return const Color(0xFFD97706);
      case 'plumbing':
        return const Color(0xFF0891B2);
      case 'carpentry':
        return const Color(0xFFB45309);
      case 'cleaning':
        return const Color(0xFF059669);
      case 'ac_repair':
        return const Color(0xFF2563EB);
      case 'painting':
        return const Color(0xFF7C3AED);
      case 'pest_control':
        return const Color(0xFFDC2626);
      case 'appliance':
        return const Color(0xFF4338CA);
      default:
        return AppColors.primary;
    }
  }
}
