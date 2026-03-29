import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../app/router.dart';

class ActiveJobScreen extends StatefulWidget {
  const ActiveJobScreen({super.key});

  @override
  State<ActiveJobScreen> createState() => _ActiveJobScreenState();
}

class _ActiveJobScreenState extends State<ActiveJobScreen> {
  // Mock states: 0: Accepted, 1: On the Way, 2: Arrived, 3: Work Started, 4: Completed
  int _statusStep = 0;
  Timer? _timer;
  int _secondsPassed = 0;

  void _advanceStatus() {
    setState(() {
      if (_statusStep < 4) {
        _statusStep++;
        if (_statusStep == 3) {
          _startTimer();
        } else if (_statusStep == 4) {
          _stopTimer();
          _showCompletionDialog();
        }
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsPassed++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Icon(
              Icons.verified_rounded,
              color: AppColors.success,
              size: 64,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Job Completed!',
                  style: AppTypography.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'You have earned ₹450 for this service.',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Back to Dashboard',
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    context.go(Routes.providerHome); // go home
                  },
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
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
          'Active Job',
          style: AppTypography.headlineMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () {
            // Confirm exit dialog could go here
            context.pop();
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map Placeholder indicating movement
                  Container(
                    height: _statusStep < 2 ? 200 : 0, // hide map once arrived
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: _statusStep < 2 ? 24 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://maps.googleapis.com/maps/api/staticmap?center=28.4595,77.0266&zoom=15&size=600x300&maptype=roadmap&markers=color:blue%7C28.4500,77.0200&markers=color:red%7C28.4595,77.0266&path=weight:3%7Ccolor:blue%7C28.4500,77.0200%7C28.4595,77.0266&key=YOUR_API_KEY',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child:
                        _statusStep == 1
                            ? Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.9,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.navigation_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Navigating... 8 mins',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),

                  if (_statusStep >= 3) ...[
                    // Work Timer
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _statusStep == 4
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.primary.withValues(alpha: 0.1),
                          border: Border.all(
                            color:
                                _statusStep == 4
                                    ? AppColors.success
                                    : AppColors.primary,
                            width: 4,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Time Elapsed',
                              style: AppTypography.labelMedium.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTime(_secondsPassed),
                              style: AppTypography.displayMedium.copyWith(
                                color:
                                    _statusStep == 4
                                        ? AppColors.success
                                        : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ], // Monospaced numbers
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],

                  // Job Details
                  Text(
                    'AC Wiring Repair',
                    style: AppTypography.headlineLarge.copyWith(
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Customer Header
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primaryTint,
                        child: Text(
                          'RA',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rahul Sharma',
                              style: AppTypography.titleMedium.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              'B-402, Sunshine Apartments',
                              style: AppTypography.bodySmall.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.phone_rounded,
                          color: AppColors.primary,
                        ),
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primaryTint,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Job Timeline (Provider Side)
                  Text(
                    'Job Status',
                    style: AppTypography.titleLarge.copyWith(
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTimelineItem(
                    isDark,
                    title: 'Job Accepted',
                    subtitle: '10:00 AM',
                    isCompleted: true, // Always completed if on this screen
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    isDark,
                    title: 'On the Way',
                    subtitle: _statusStep >= 1 ? '10:05 AM' : 'Pending',
                    isCompleted: _statusStep >= 1,
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    isDark,
                    title: 'Arrived at Location',
                    subtitle: _statusStep >= 2 ? '10:13 AM' : 'Pending',
                    isCompleted: _statusStep >= 2,
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    isDark,
                    title: 'Work Started',
                    subtitle: _statusStep >= 3 ? '10:15 AM' : 'Pending',
                    isCompleted: _statusStep >= 3,
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    isDark,
                    title: 'Work Completed',
                    subtitle: _statusStep == 4 ? '11:05 AM' : 'Pending',
                    isCompleted: _statusStep == 4,
                    isLast: true,
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: AppButton(
          text: _getButtonText(),
          onPressed: _statusStep == 4 ? null : _advanceStatus,
          // Change button color to success if taking final action
          // Note: AppButton doesn't support custom colors out of the box so we'll just stick to primary style
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (_statusStep) {
      case 0:
        return 'Swipe to Start Trip'; // Could implement a slider later, button for now
      case 1:
        return 'Mark Arrived';
      case 2:
        return 'Start Work';
      case 3:
        return 'Complete Job';
      case 4:
        return 'Finished';
      default:
        return 'Update Status';
    }
  }

  Widget _buildTimelineItem(
    bool isDark, {
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isCompleted
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight),
                  width: 2,
                ),
              ),
              child:
                  isCompleted
                      ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      )
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color:
                    isCompleted
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.dividerDark
                            : AppColors.dividerLight),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  color:
                      isDark
                          ? (isCompleted
                              ? AppColors.textPrimaryDark
                              : AppColors.textSecondaryDark)
                          : (isCompleted
                              ? AppColors.textPrimaryLight
                              : AppColors.textSecondaryLight),
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color:
                      isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
