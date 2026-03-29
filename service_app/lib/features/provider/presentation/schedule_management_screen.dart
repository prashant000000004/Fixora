import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class ScheduleManagementScreen extends StatefulWidget {
  const ScheduleManagementScreen({super.key});

  @override
  State<ScheduleManagementScreen> createState() =>
      _ScheduleManagementScreenState();
}

class _ScheduleManagementScreenState extends State<ScheduleManagementScreen> {
  // Mock data for schedule
  final List<Map<String, dynamic>> _schedule = [
    {'day': 'Monday', 'isActive': true, 'start': '09:00 AM', 'end': '06:00 PM'},
    {
      'day': 'Tuesday',
      'isActive': true,
      'start': '09:00 AM',
      'end': '06:00 PM',
    },
    {
      'day': 'Wednesday',
      'isActive': true,
      'start': '09:00 AM',
      'end': '06:00 PM',
    },
    {
      'day': 'Thursday',
      'isActive': true,
      'start': '09:00 AM',
      'end': '06:00 PM',
    },
    {'day': 'Friday', 'isActive': true, 'start': '09:00 AM', 'end': '06:00 PM'},
    {
      'day': 'Saturday',
      'isActive': false,
      'start': '10:00 AM',
      'end': '04:00 PM',
    },
    {
      'day': 'Sunday',
      'isActive': false,
      'start': '10:00 AM',
      'end': '02:00 PM',
    },
  ];

  Future<void> _selectTime(
    BuildContext context,
    int index,
    bool isStart,
  ) async {
    final TimeOfDay initialTime =
        TimeOfDay.now(); // In a real app, parse from schedule[index]['start'/'end']

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _schedule[index]['start'] = picked.format(context);
        } else {
          _schedule[index]['end'] = picked.format(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Schedule',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Working Hours',
              style: AppTypography.titleLarge.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set your availability to receive job requests during your preferred hours.',
              style: AppTypography.bodyMedium.copyWith(
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),

            // List of days
            ...List.generate(_schedule.length, (index) {
              final daySchedule = _schedule[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isDark ? AppColors.dividerDark : AppColors.dividerLight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          daySchedule['day'] as String,
                          style: AppTypography.titleMedium.copyWith(
                            color:
                                isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Switch(
                          value: daySchedule['isActive'] as bool,
                          activeColor: AppColors.success,
                          onChanged: (value) {
                            setState(() {
                              daySchedule['isActive'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (daySchedule['isActive'] as bool) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimePicker(
                              isDark,
                              label: 'From',
                              time: daySchedule['start'] as String,
                              onTap: () => _selectTime(context, index, true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimePicker(
                              isDark,
                              label: 'To',
                              time: daySchedule['end'] as String,
                              onTap: () => _selectTime(context, index, false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Save Schedule',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Schedule updated successfully'),
                    ),
                  );
                  context.pop();
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    bool isDark, {
    required String label,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color:
                  isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: AppTypography.bodyMedium.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                ),
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
