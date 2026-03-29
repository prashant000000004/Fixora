import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import 'dart:math';
import '../../../core/widgets/empty_state_widget.dart';

class ProviderReviewsScreen extends ConsumerWidget {
  const ProviderReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Reviews',
          style: AppTypography.headlineMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Overall Rating Overview
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color:
                            isDark
                                ? AppColors.dividerDark
                                : AppColors.dividerLight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Large Rating Number
                        Column(
                          children: [
                            Text(
                              '4.8',
                              style: AppTypography.displayLarge.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 48,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < 4
                                      ? Icons.star_rounded
                                      : Icons.star_half_rounded,
                                  color: AppColors.warning,
                                  size: 24,
                                );
                              }),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Based on 124 reviews',
                              style: AppTypography.labelMedium.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 32),

                        // Rating Bars
                        Expanded(
                          child: Column(
                            children: [
                              _buildRatingBar(isDark, 5, 0.8),
                              _buildRatingBar(isDark, 4, 0.15),
                              _buildRatingBar(isDark, 3, 0.03),
                              _buildRatingBar(isDark, 2, 0.01),
                              _buildRatingBar(isDark, 1, 0.01),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Section Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent Reviews',
                      style: AppTypography.titleLarge.copyWith(
                        color:
                            isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Reviews List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver:
                5 ==
                        0 // In a real app this would check the reviews list length
                    ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: EmptyStateWidget(
                          icon: Icons.star_border_rounded,
                          title: 'No reviews yet',
                          subtitle:
                              'Complete jobs to start building your reputation',
                        ),
                      ),
                    )
                    : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildReviewItem(isDark, index);
                        },
                        childCount: 5, // Mock 5 reviews
                      ),
                    ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }

  Widget _buildRatingBar(bool isDark, int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$stars',
            style: AppTypography.labelMedium.copyWith(
              color:
                  isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor:
                    isDark ? AppColors.dividerDark : AppColors.dividerLight,
                color: AppColors.warning,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(bool isDark, int index) {
    final names = ['Rahul S.', 'Priya M.', 'Amit K.', 'Sneha R.', 'Vikram B.'];
    final reviews = [
      'Excellent service! He arrived on time and fixed the AC wiring issue quickly. Very professional.',
      'Good work, neat and clean. Took a bit longer than expected to find the fault, but overall satisfied.',
      'Perfect. Exactly what I needed. Highly recommended electrician.',
      'Response time could be better, but the quality of work was outstanding. Worth the wait.',
      'Very knowledgeable. Not only fixed the problem but explained what went wrong to prevent it in the future.',
    ];

    // Deterministic random mock data
    final random = Random(index);
    final rating = 4 + random.nextInt(2); // 4 or 5
    final daysAgo = 1 + random.nextInt(14); // 1 to 14 days ago

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryTint,
                    radius: 20,
                    child: Text(
                      names[index].substring(0, 1),
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        names[index],
                        style: AppTypography.titleMedium.copyWith(
                          color:
                              isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$daysAgo days ago',
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
              Row(
                children: List.generate(5, (starIndex) {
                  return Icon(
                    starIndex < rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.warning,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            reviews[index],
            style: AppTypography.bodyMedium.copyWith(
              color:
                  isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
