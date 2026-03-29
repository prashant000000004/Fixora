import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../providers/booking_providers.dart';

/// Step 1: Select Date and Time Slot.
class ScheduleStep extends ConsumerStatefulWidget {
  const ScheduleStep({super.key});

  @override
  ConsumerState<ScheduleStep> createState() => _ScheduleStepState();
}

class _ScheduleStepState extends ConsumerState<ScheduleStep> {
  DateTime? _selectedDate;
  String? _selectedTime;

  final List<String> _timeSlots = [
    '09:00 AM - 10:00 AM',
    '10:30 AM - 11:30 AM',
    '12:00 PM - 01:00 PM',
    '02:00 PM - 03:00 PM',
    '04:00 PM - 05:00 PM',
    '06:00 PM - 07:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select next available day if draft builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final draft = ref.read(bookingDraftProvider);
      if (draft != null) {
        setState(() {
          _selectedDate =
              draft.scheduledDate ??
              DateTime.now().add(const Duration(days: 1));
          _selectedTime = draft.timeSlot;
        });
        _updateDraft();
      }
    });
  }

  void _updateDraft() {
    if (_selectedDate != null && _selectedTime != null) {
      ref
          .read(bookingDraftProvider.notifier)
          .setDateTime(_selectedDate!, _selectedTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Generate next 7 days
    final now = DateTime.now();
    final dates = List.generate(7, (i) => now.add(Duration(days: i)));

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'When do you need the service?',
          style: AppTypography.headlineMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 24),

        // ─── Date Picker (Horizontal List) ─────────────
        Text(
          'Select Date',
          style: AppTypography.titleMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected =
                  _selectedDate?.day == date.day &&
                  _selectedDate?.month == date.month &&
                  _selectedDate?.year == date.year;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                  _updateDraft();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.cardDark
                                : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date), // 'Mon'
                        style: AppTypography.labelMedium.copyWith(
                          color:
                              isSelected
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: AppTypography.headlineSmall.copyWith(
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 32),

        // ─── Time Slot Picker (Grid) ───────────────────
        Text(
          'Select Time Slot',
          style: AppTypography.titleMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedTime = time);
                    _updateDraft();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width:
                        (MediaQuery.of(context).size.width - 48 - 12) /
                        2, // 2 columns
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryTint
                              : (isDark
                                  ? AppColors.cardDark
                                  : AppColors.cardLight),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.dividerDark
                                    : AppColors.dividerLight),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        time,
                        style: AppTypography.labelLarge.copyWith(
                          color:
                              isSelected
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
