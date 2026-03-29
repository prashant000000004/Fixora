import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // User Info
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'User',
                  style: AppTypography.headlineMedium.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.phone ?? '',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Menu Options
          _ProfileMenuItem(
            icon: Icons.location_on_rounded,
            title: 'Saved Addresses',
            onTap: () => context.push(Routes.savedAddresses),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _ProfileMenuItem(
            icon: Icons.favorite_rounded,
            title: 'Saved Providers',
            onTap: () => context.push(Routes.savedProviders),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _ProfileMenuItem(
            icon: Icons.history_rounded,
            title: 'Booking History',
            onTap: () => context.push(Routes.myBookings),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _ProfileMenuItem(
            icon: Icons.support_agent_rounded,
            title: 'Help & Support',
            onTap: () => context.push(Routes.support),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _ProfileMenuItem(
            icon: Icons.card_giftcard_rounded,
            title: 'Refer & Earn',
            onTap: () => context.push(Routes.referral),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _ProfileMenuItem(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: () {
              ref.read(authProvider.notifier).signOut();
              context.go(Routes.login);
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDark;
  final Color? iconColor;
  final Color? textColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDark,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  color:
                      textColor ??
                      (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color:
                  isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
