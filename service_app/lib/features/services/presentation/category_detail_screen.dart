import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/service_providers.dart';
import '../domain/service_models.dart';
import 'provider_profile_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';

/// Category detail screen — shows sub-services + providers for a category.
class CategoryDetailScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;
  final Color categoryColor;

  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  ConsumerState<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen> {
  String _selectedFilter = 'rating';
  final List<String> _filters = ['Highest Rated', 'Closest', 'Available Now'];
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subServicesAsync = ref.watch(subServicesProvider(widget.categoryId));
    final providersAsync = ref.watch(providersProvider(_selectedFilter));

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: CustomScrollView(
        slivers: [
          // ─── Collapsing Header ─────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: isDark ? AppColors.cardDark : widget.categoryColor,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_rounded, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.categoryName,
                style: AppTypography.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.categoryColor,
                      widget.categoryColor.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(widget.categoryId),
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),

          // ─── Sub-services Section ──────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Services',
                style: AppTypography.headlineMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
          subServicesAsync.when(
            data:
                (subServices) => SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final sub = subServices[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: _SubServiceCard(
                        subService: sub,
                        categoryColor: widget.categoryColor,
                        isDark: isDark,
                        onTap: () {
                          context.push(
                            Routes.bookingFlow,
                            extra: {'service': sub, 'provider': null},
                          );
                        },
                      ),
                    );
                  }, childCount: subServices.length),
                ),
            loading:
                () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            error:
                (error, _) => SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'Failed to load services',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
          ),

          // ─── Filter Chips ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Providers',
                    style: AppTypography.headlineMedium.copyWith(
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isSelected = index == _selectedFilterIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilterIndex = index;
                              _selectedFilter =
                                  ['rating', 'distance', 'available'][index];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? widget.categoryColor
                                      : (isDark
                                          ? AppColors.cardDark
                                          : AppColors.cardLight),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  isSelected
                                      ? null
                                      : Border.all(
                                        color:
                                            isDark
                                                ? AppColors.dividerDark
                                                : AppColors.dividerLight,
                                      ),
                            ),
                            child: Text(
                              _filters[index],
                              style: AppTypography.labelMedium.copyWith(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight),
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Provider List ─────────────────────────────
          providersAsync.when(
            data:
                (providers) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final provider = providers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProviderCard(
                          provider: provider,
                          categoryColor: widget.categoryColor,
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ProviderProfileScreen(
                                      providerId: provider.id,
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    }, childCount: providers.length),
                  ),
                ),
            loading:
                () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            error:
                (error, _) => SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'Failed to load providers',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'electrical':
        return Icons.electrical_services_rounded;
      case 'plumbing':
        return Icons.plumbing_rounded;
      case 'carpentry':
        return Icons.carpenter_rounded;
      case 'cleaning':
        return Icons.cleaning_services_rounded;
      case 'ac_repair':
        return Icons.ac_unit_rounded;
      case 'painting':
        return Icons.format_paint_rounded;
      case 'pest_control':
        return Icons.pest_control_rounded;
      case 'appliance':
        return Icons.build_rounded;
      default:
        return Icons.handyman_rounded;
    }
  }
}

// ─── Sub-Service Card ───────────────────────────────────────────
class _SubServiceCard extends StatelessWidget {
  final SubService subService;
  final Color categoryColor;
  final bool isDark;
  final VoidCallback onTap;

  const _SubServiceCard({
    required this.subService,
    required this.categoryColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subService.name,
                    style: AppTypography.titleLarge.copyWith(
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subService.description,
                    style: AppTypography.bodySmall.copyWith(
                      color:
                          isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${subService.minPrice} - ₹${subService.maxPrice}',
                        style: AppTypography.titleMedium.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color:
                            isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        subService.estimatedTime,
                        style: AppTypography.labelSmall.copyWith(
                          color:
                              isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.starFilled,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${subService.avgRating}',
                        style: AppTypography.labelSmall.copyWith(
                          color:
                              isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${subService.totalBookings} bookings',
                        style: AppTypography.labelSmall.copyWith(
                          color:
                              isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: categoryColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Provider Card ──────────────────────────────────────────────
class _ProviderCard extends StatefulWidget {
  final ServiceProvider provider;
  final Color categoryColor;
  final bool isDark;
  final VoidCallback onTap;

  const _ProviderCard({
    required this.provider,
    required this.categoryColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<_ProviderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.categoryColor.withValues(alpha: 0.2),
                          widget.categoryColor.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.provider.name[0],
                        style: AppTypography.headlineMedium.copyWith(
                          color: widget.categoryColor,
                        ),
                      ),
                    ),
                  ),
                  if (widget.provider.isOnline)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.online,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                widget.isDark
                                    ? AppColors.cardDark
                                    : AppColors.cardLight,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.provider.name,
                            style: AppTypography.titleLarge.copyWith(
                              color:
                                  widget.isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        if (widget.provider.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successTint,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 12,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Verified',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Skills
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children:
                          widget.provider.skills
                              .take(3)
                              .map(
                                (skill) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.categoryColor.withValues(
                                      alpha: 0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    skill,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: widget.categoryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.starFilled,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.provider.rating}',
                          style: AppTypography.labelLarge.copyWith(
                            color:
                                widget.isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' (${widget.provider.totalReviews})',
                          style: AppTypography.labelSmall.copyWith(
                            color:
                                widget.isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color:
                              widget.isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${widget.provider.distanceKm} km',
                          style: AppTypography.labelSmall.copyWith(
                            color:
                                widget.isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.work_outline_rounded,
                          size: 14,
                          color:
                              widget.isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${widget.provider.experienceYears} yrs',
                          style: AppTypography.labelSmall.copyWith(
                            color:
                                widget.isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
