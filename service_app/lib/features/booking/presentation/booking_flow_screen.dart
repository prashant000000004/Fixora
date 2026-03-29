import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../services/domain/service_models.dart';
import '../providers/booking_providers.dart';
import 'steps/schedule_step.dart';
import 'steps/address_step.dart';
import 'steps/details_step.dart';
import 'steps/summary_step.dart';

/// The multi-step booking flow shell.
class BookingFlowScreen extends ConsumerStatefulWidget {
  final SubService service;
  final ServiceProvider? provider;

  const BookingFlowScreen({super.key, required this.service, this.provider});

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    // Initialize draft on next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(bookingDraftProvider.notifier)
          .startBooking(widget.service, provider: widget.provider);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitBooking();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ref.read(bookingDraftProvider.notifier).clear();
      Navigator.pop(context);
    }
  }

  bool _isSubmitting = false;

  Future<void> _submitBooking() async {
    final draft = ref.read(bookingDraftProvider);
    if (draft == null) return;

    // Optional: Get actual customer ID from auth provider if available
    final customerId = 'temp_user_id'; // backend relies on JWT mostly

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(bookingRepositoryProvider);
      await repository.createBooking(draft, customerId);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _buildSuccessModal(context),
        );

        // Wait 2.5 seconds to show the animation, then go home
        await Future.delayed(const Duration(milliseconds: 2500));
        if (mounted) {
          ref.read(bookingDraftProvider.notifier).clear();
          context.go('/home'); // Go to home using router
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildSuccessModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.successTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Booking Confirmed!',
              style: AppTypography.headlineMedium.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your request has been sent to the provider. You can track status in My Bookings.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Schedule';
      case 1:
        return 'Address';
      case 2:
        return 'Details';
      case 3:
        return 'Summary';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final draft = ref.watch(bookingDraftProvider);

    if (draft == null) {
      return Scaffold(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Basic validation to enable 'Continue'
    bool canProceed = true;
    if (_currentStep == 0) {
      canProceed = draft.scheduledDate != null && draft.timeSlot != null;
    } else if (_currentStep == 1) {
      canProceed = draft.address != null;
    } else if (_currentStep == 2) {
      // Problem description optional or could be required
      canProceed = true;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header & Progress ─────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                    onPressed: _prevStep,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStepTitle(),
                    style: AppTypography.titleLarge.copyWith(
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Step ${_currentStep + 1} of $_totalSteps',
                    style: AppTypography.labelMedium.copyWith(
                      color:
                          isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(
                        right: index == _totalSteps - 1 ? 0 : 8,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color:
                            index <= _currentStep
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.dividerDark
                                    : AppColors.dividerLight),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ─── Page Content ──────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent swipe to skip validation
                onPageChanged: (idx) {
                  setState(() => _currentStep = idx);
                },
                children: const [
                  ScheduleStep(),
                  AddressStep(),
                  DetailsStep(),
                  SummaryStep(),
                ],
              ),
            ),

            // ─── Bottom CTA ────────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: AppButton(
                text:
                    _currentStep == _totalSteps - 1
                        ? (_isSubmitting ? 'Booking...' : 'Confirm & Book')
                        : 'Continue',
                onPressed: (canProceed && !_isSubmitting) ? _nextStep : null,
                isLoading: _isSubmitting,
                icon:
                    _currentStep == _totalSteps - 1
                        ? Icons.check_circle_outline_rounded
                        : Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
