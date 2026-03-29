import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/service_providers.dart';
import '../domain/service_models.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';

/// Full provider profile screen with portfolio, reviews, and book now CTA.
class ProviderProfileScreen extends ConsumerWidget {
  final String providerId;

  const ProviderProfileScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final providerAsync = ref.watch(providerByIdProvider(providerId));

    return providerAsync.when(
      loading:
          () => Scaffold(
            backgroundColor:
                isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            body: const Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, _) => Scaffold(
            backgroundColor:
                isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            body: Center(
              child: Text(
                'Failed to load provider',
                style: AppTypography.bodyLarge,
              ),
            ),
          ),
      data: (provider) {
        if (provider == null) {
          return Scaffold(
            body: Center(
              child: Text('Provider not found', style: AppTypography.bodyLarge),
            ),
          );
        }

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // ─── Profile Header ────────────────────────
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16,
                        bottom: 24,
                      ),
                      child: Column(
                        children: [
                          // Back button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? AppColors.cardDark
                                              : AppColors.cardLight,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.06,
                                          ),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: 18,
                                      color:
                                          isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? AppColors.cardDark
                                              : AppColors.cardLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite_border_rounded,
                                      size: 20,
                                      color:
                                          isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Profile card
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? AppColors.cardDark
                                      : AppColors.cardLight,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Avatar
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primaryLight,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      provider.name[0],
                                      style: AppTypography.displayMedium
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Name + verified
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      provider.name,
                                      style: AppTypography.headlineLarge
                                          .copyWith(
                                            color:
                                                isDark
                                                    ? AppColors.textPrimaryDark
                                                    : AppColors
                                                        .textPrimaryLight,
                                          ),
                                    ),
                                    if (provider.isVerified) ...[
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.verified_rounded,
                                        size: 22,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Experience
                                Text(
                                  '${provider.experienceYears} years experience',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color:
                                        isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Stats row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _StatItem(
                                      value: '${provider.rating}',
                                      label: 'Rating',
                                      icon: Icons.star_rounded,
                                      iconColor: AppColors.starFilled,
                                      isDark: isDark,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color:
                                          isDark
                                              ? AppColors.dividerDark
                                              : AppColors.dividerLight,
                                    ),
                                    _StatItem(
                                      value: '${provider.totalJobsCompleted}',
                                      label: 'Jobs Done',
                                      icon: Icons.check_circle_rounded,
                                      iconColor: AppColors.success,
                                      isDark: isDark,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color:
                                          isDark
                                              ? AppColors.dividerDark
                                              : AppColors.dividerLight,
                                    ),
                                    _StatItem(
                                      value: '${provider.totalReviews}',
                                      label: 'Reviews',
                                      icon: Icons.rate_review_rounded,
                                      iconColor: AppColors.info,
                                      isDark: isDark,
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

                  // ─── Skill Tags ────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skills',
                            style: AppTypography.headlineSmall.copyWith(
                              color:
                                  isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                provider.skills
                                    .map(
                                      (skill) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryTint,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          skill,
                                          style: AppTypography.labelMedium
                                              .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ─── About ────────────────────────────────
                  if (provider.aboutMe.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: AppTypography.headlineSmall.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.aboutMe,
                              style: AppTypography.bodyMedium.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ─── Reviews ──────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews (${provider.totalReviews})',
                            style: AppTypography.headlineSmall.copyWith(
                              color:
                                  isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (provider.reviews.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? AppColors.cardDark
                                    : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'No reviews yet',
                              style: AppTypography.bodyMedium.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textTertiaryDark
                                        : AppColors.textTertiaryLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ReviewCard(
                              review: provider.reviews[index],
                              isDark: isDark,
                            ),
                          );
                        }, childCount: provider.reviews.length),
                      ),
                    ),
                ],
              ),

              // ─── Sticky Bottom CTA ─────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    MediaQuery.of(context).padding.bottom + 16,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Distance + status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${provider.distanceKm} km away',
                            style: AppTypography.titleMedium.copyWith(
                              color:
                                  isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      provider.isOnline
                                          ? AppColors.online
                                          : AppColors.offline,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                provider.isOnline ? 'Online now' : 'Offline',
                                style: AppTypography.labelSmall.copyWith(
                                  color:
                                      provider.isOnline
                                          ? AppColors.online
                                          : AppColors.offline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),

                      // Book now button
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                // Use a generic fallback service when booking from provider profile
                                const defaultService = SubService(
                                  id: 'ac_mock',
                                  categoryId: 'ac_repair',
                                  name: 'AC Regular Service',
                                  description: 'Standard AC servicing',
                                  minPrice: 499,
                                  maxPrice: 699,
                                  estimatedTime: '45 mins',
                                  avgRating: 4.8,
                                  totalBookings: 120,
                                );

                                context.push(
                                  Routes.bookingFlow,
                                  extra: {
                                    'service': defaultService,
                                    'provider': provider,
                                  },
                                );
                              },
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Book Now',
                                      style: AppTypography.titleLarge.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Stat Item Widget ───────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isDark;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTypography.headlineSmall.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color:
                isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
          ),
        ),
      ],
    );
  }
}

// ─── Review Card Widget ─────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Review review;
  final bool isDark;

  const _ReviewCard({required this.review, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.customerName[0],
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: AppTypography.titleMedium.copyWith(
                        color:
                            isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      _formatDate(review.createdAt),
                      style: AppTypography.labelSmall.copyWith(
                        color:
                            isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Stars
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color:
                        i < review.rating.round()
                            ? AppColors.starFilled
                            : AppColors.starEmpty,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Comment
          Text(
            review.comment,
            style: AppTypography.bodyMedium.copyWith(
              color:
                  isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),

          // Tags
          if (review.tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children:
                  review.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successTint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
