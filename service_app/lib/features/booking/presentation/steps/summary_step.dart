import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../providers/booking_providers.dart';

/// Step 4: Booking Summary and Price Estimate.
class SummaryStep extends ConsumerWidget {
  const SummaryStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final draft = ref.watch(bookingDraftProvider);

    if (draft == null) {
      return const SizedBox.shrink();
    }

    final dateStr =
        draft.scheduledDate != null
            ? DateFormat('EEEE, MMM d, yyyy').format(draft.scheduledDate!)
            : 'TBD';
    final timeStr = draft.timeSlot ?? 'TBD';

    // Mock pricing calculations
    final itemTotal = draft.service.minPrice.toDouble();
    final taxes = itemTotal * 0.18; // 18% GST
    final platformFee = 49.0;
    final grandTotal = itemTotal + taxes + platformFee;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Booking Summary',
          style: AppTypography.headlineMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 24),

        // Service & Schedule Info
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.build_circle_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          draft.service.name,
                          style: AppTypography.titleLarge.copyWith(
                            color:
                                isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                          ),
                        ),
                        if (draft.suggestedProvider != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Provider: ${draft.suggestedProvider!.name}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
              const SizedBox(height: 24),

              // Date & Time
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: AppTypography.titleMedium.copyWith(
                          color:
                              isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: AppTypography.bodySmall.copyWith(
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
              const SizedBox(height: 24),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 20,
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          draft.address?.label ?? 'No Address Selected',
                          style: AppTypography.titleMedium.copyWith(
                            color:
                                isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          draft.address?.address ?? '',
                          style: AppTypography.bodySmall.copyWith(
                            color:
                                isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Price Breakdown
        Text(
          'Payment Estimate',
          style: AppTypography.titleLarge.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
          ),
          child: Column(
            children: [
              _buildPriceRow(
                'Service Charge',
                '₹${itemTotal.toStringAsFixed(0)}',
                isDark,
                isBold: false,
              ),
              const SizedBox(height: 12),
              _buildPriceRow(
                'Taxes & Fee',
                '₹${taxes.toStringAsFixed(0)}',
                isDark,
                isBold: false,
              ),
              const SizedBox(height: 12),
              _buildPriceRow(
                'Platform Fee',
                '₹${platformFee.toStringAsFixed(0)}',
                isDark,
                isBold: false,
              ),
              const SizedBox(height: 16),
              Divider(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
              const SizedBox(height: 16),
              _buildPriceRow(
                'Total Estimate',
                '₹${grandTotal.toStringAsFixed(0)}',
                isDark,
                isBold: true,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Final price may vary if additional parts or labor are required during the service.',
                style: AppTypography.labelSmall.copyWith(
                  color:
                      isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    String amount,
    bool isDark, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              isBold
                  ? AppTypography.titleMedium.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  )
                  : AppTypography.bodyMedium.copyWith(
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
        ),
        Text(
          amount,
          style: AppTypography.titleMedium.copyWith(
            color:
                color ??
                (isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
