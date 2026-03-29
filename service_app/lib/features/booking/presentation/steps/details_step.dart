import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../providers/booking_providers.dart';

/// Step 3: Add Problem Details and Photos.
class DetailsStep extends ConsumerStatefulWidget {
  const DetailsStep({super.key});

  @override
  ConsumerState<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends ConsumerState<DetailsStep> {
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final draft = ref.read(bookingDraftProvider);
      if (draft != null && draft.problemDescription.isNotEmpty) {
        _descController.text = draft.problemDescription;
      }
    });
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    ref.read(bookingDraftProvider.notifier).setProblemDetails(val);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Any specific instructions?',
          style: AppTypography.headlineMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Help the professional come prepared by describing the issue.',
          style: AppTypography.bodyMedium.copyWith(
            color:
                isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 32),

        // Text Area
        Text(
          'Description',
          style: AppTypography.titleMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
          ),
          child: TextField(
            controller: _descController,
            onChanged: _onChanged,
            maxLines: 5,
            maxLength: 500,
            style: AppTypography.bodyLarge.copyWith(
              color:
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
            ),
            decoration: InputDecoration(
              hintText:
                  'e.g., The fan is making a rattling noise and spins very slowly...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color:
                    isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '', // Hide default counter
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Photo Upload Mock
        Text(
          'Add Photos (Optional)',
          style: AppTypography.titleMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // Mock image picker
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary,
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
                    SizedBox(height: 4),
                    Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
