import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_button.dart';

/// 3-page parallax onboarding with premium animations.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      icon: Icons.home_repair_service_rounded,
      iconColor: Color(0xFF4F46E5),
      bgGradient: [Color(0xFFEEF2FF), Color(0xFFC7D2FE)],
      title: 'Expert Services\nAt Your Doorstep',
      subtitle:
          'From electricians to plumbers — verified professionals just a tap away',
    ),
    _OnboardingData(
      icon: Icons.schedule_rounded,
      iconColor: Color(0xFF059669),
      bgGradient: [Color(0xFFECFDF5), Color(0xFFA7F3D0)],
      title: 'Book in Seconds,\nTrack in Real-Time',
      subtitle:
          'Schedule instantly, watch your provider arrive live on the map',
    ),
    _OnboardingData(
      icon: Icons.verified_user_rounded,
      iconColor: Color(0xFFD97706),
      bgGradient: [Color(0xFFFFFBEB), Color(0xFFFDE68A)],
      title: 'Trusted & Transparent\nPricing',
      subtitle: 'No hidden charges. See price estimates upfront. Pay your way.',
    ),
  ];

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyHasSeenOnboarding, true);
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    'Skip',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index], isDark: isDark);
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _DotIndicator(
                        isActive: index == _currentPage,
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Button
                  if (_currentPage == _pages.length - 1)
                    AppButton(
                      text: 'Get Started',
                      onPressed: _completeOnboarding,
                      showShimmer: true,
                    )
                  else
                    AppButton(
                      text: 'Next',
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single onboarding page with parallax icon animation.
class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final bool isDark;

  const _OnboardingPage({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration area with gradient background
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [
                          data.iconColor.withValues(alpha: 0.15),
                          data.iconColor.withValues(alpha: 0.05),
                        ]
                        : data.bgGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: data.iconColor.withValues(alpha: 0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(data.icon, size: 80, color: data.iconColor),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(
              color:
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color:
                  isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated dot indicator.
class _DotIndicator extends StatelessWidget {
  final bool isActive;
  final bool isDark;

  const _DotIndicator({required this.isActive, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            isActive
                ? AppColors.primary
                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Data model for onboarding pages.
class _OnboardingData {
  final IconData icon;
  final Color iconColor;
  final List<Color> bgGradient;
  final String title;
  final String subtitle;

  const _OnboardingData({
    required this.icon,
    required this.iconColor,
    required this.bgGradient,
    required this.title,
    required this.subtitle,
  });
}
