import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/empty_state_widget.dart';

class SavedProvidersScreen extends StatefulWidget {
  const SavedProvidersScreen({super.key});

  @override
  State<SavedProvidersScreen> createState() => _SavedProvidersScreenState();
}

class _SavedProvidersScreenState extends State<SavedProvidersScreen> {
  // Mock data for saved providers
  final List<Map<String, dynamic>> _providers = [
    {
      'name': 'Rahul Sharma',
      'category': 'Electrician',
      'rating': 4.8,
      'jobs': 120,
      'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
    },
    {
      'name': 'Amit Patel',
      'category': 'Plumber',
      'rating': 4.9,
      'jobs': 240,
      'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704e',
    },
    {
      'name': 'Priya Singh',
      'category': 'Cleaning',
      'rating': 4.7,
      'jobs': 85,
      'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704f',
    },
  ];

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
          'Saved Providers',
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
      body:
          _providers.isEmpty
              ? const EmptyStateWidget(
                icon: Icons.favorite_border_rounded,
                title: 'No saved providers',
                subtitle:
                    'Tap the heart icon on any provider to save them here for quick access',
              )
              : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _providers.length,
                itemBuilder: (context, index) {
                  final provider = _providers[index];
                  return _buildProviderCard(context, isDark, provider, index);
                },
              ),
    );
  }

  Widget _buildProviderCard(
    BuildContext context,
    bool isDark,
    Map<String, dynamic> provider,
    int index,
  ) {
    return Dismissible(
      key: ValueKey(provider['name']),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.only(right: 24),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: AppColors.error),
      ),
      onDismissed: (_) {
        final removed = _providers.removeAt(index);
        setState(() {});
        AppSnackBar.info(context, 'Removed ${removed['name']} from favorites');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(provider['image'] as String),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider['name'] as String,
                    style: AppTypography.titleMedium.copyWith(
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider['category'] as String,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.starFilled,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${provider['rating']} (${provider['jobs']} jobs)',
                        style: AppTypography.labelMedium.copyWith(
                          color:
                              isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_rounded, color: AppColors.error),
              onPressed: () {
                final removed = _providers.removeAt(index);
                setState(() {});
                AppSnackBar.info(
                  context,
                  'Removed ${removed['name']} from favorites',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
