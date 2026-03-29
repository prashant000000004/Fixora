import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../services/presentation/category_detail_screen.dart';
import '../../services/presentation/search_screen.dart';
import '../../services/presentation/provider_profile_screen.dart';

import '../../../core/utils/location_service.dart';
import '../../../core/widgets/skeleton_loader.dart';

/// Home screen — the main hub after authentication.
/// This will be expanded in Phase 3 with 5 zones.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String _locationText = 'Detecting...';
  bool _locationFetched = false;

  @override
  void initState() {
    super.initState();
    _simulateLoad();
    _fetchCurrentLocation();
  }

  Future<void> _simulateLoad() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentPosition();
      final address = await LocationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (mounted) {
        setState(() {
          _locationText = address;
          _locationFetched = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationText = 'Location unavailable';
          _locationFetched = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ─── Zone 1: Top Bar ─────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    // Location
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryTint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Current Location',
                                    style: AppTypography.labelMedium.copyWith(
                                      color:
                                          isDark
                                              ? AppColors.textTertiaryDark
                                              : AppColors.textTertiaryLight,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16,
                                    color:
                                        isDark
                                            ? AppColors.textTertiaryDark
                                            : AppColors.textTertiaryLight,
                                  ),
                                ],
                              ),
                              Text(
                                _locationText,
                                style: AppTypography.titleMedium.copyWith(
                                  color:
                                      _locationFetched
                                          ? (isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight)
                                          : (isDark
                                              ? AppColors.textTertiaryDark
                                              : AppColors.textTertiaryLight),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          ),
                        ],
                      ),
                    ),

                    // Notification bell
                    GestureDetector(
                      onTap: () => context.push(Routes.notifications),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? AppColors.cardDark
                                      : AppColors.cardLight,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color:
                                  isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                              size: 22,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Profile avatar
                    GestureDetector(
                      onTap: () => context.push(Routes.profile),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Zone 2: Search Bar ─────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color:
                              isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'What do you need fixed today?',
                            style: AppTypography.bodyMedium.copyWith(
                              color:
                                  isDark
                                      ? AppColors.textTertiaryDark
                                      : AppColors.textTertiaryLight,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTint,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.mic_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── Zone 3: Service Categories ─────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Text(
                  'Services',
                  style: AppTypography.headlineMedium.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate(
                  _isLoading
                      ? List.generate(
                        6,
                        (_) => const SkeletonLoader.card(
                          height: 120,
                          borderRadius: 16,
                        ),
                      )
                      : _serviceCategories.map((cat) {
                        return _ServiceCategoryCard(
                          icon: cat.icon,
                          name: cat.name,
                          color: cat.color,
                          startPrice: cat.startPrice,
                          categoryId: cat.categoryId,
                          isDark: isDark,
                        );
                      }).toList(),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
              ),
            ),

            // ─── Zone 4: Available Near You ─────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Near You',
                      style: AppTypography.headlineMedium.copyWith(
                        color:
                            isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See all',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    if (_isLoading) return const SkeletonProviderCard();
                    return _NearbyProviderCard(isDark: isDark, index: index);
                  },
                ),
              ),
            ),

            // ─── Zone 5: Popular in Your Area ───────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Text(
                  'Popular in Your Area',
                  style: AppTypography.headlineMedium.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child:
                        _isLoading
                            ? const SkeletonServiceCard()
                            : _PopularServiceCard(isDark: isDark, index: index),
                  );
                }, childCount: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Service Category Card ──────────────────────────────────────
class _ServiceCategoryCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final Color color;
  final int startPrice;
  final String categoryId;
  final bool isDark;

  const _ServiceCategoryCard({
    required this.icon,
    required this.name,
    required this.color,
    required this.startPrice,
    required this.categoryId,
    required this.isDark,
  });

  @override
  State<_ServiceCategoryCard> createState() => _ServiceCategoryCardState();
}

class _ServiceCategoryCardState extends State<_ServiceCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        if (widget.categoryId != 'more') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => CategoryDetailScreen(
                    categoryId: widget.categoryId,
                    categoryName: widget.name,
                    categoryColor: widget.color,
                  ),
            ),
          );
        }
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color:
                widget.isDark
                    ? widget.color.withValues(alpha: 0.12)
                    : widget.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: AppTypography.labelMedium.copyWith(
                  color:
                      widget.isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${widget.startPrice}+',
                style: AppTypography.labelSmall.copyWith(
                  color:
                      widget.isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Nearby Provider Card ───────────────────────────────────────
class _NearbyProviderCard extends StatelessWidget {
  final bool isDark;
  final int index;

  const _NearbyProviderCard({required this.isDark, required this.index});

  static const _names = [
    'Rahul K.',
    'Suresh M.',
    'Aman S.',
    'Priya D.',
    'Vikash P.',
  ];
  static const _skills = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Cleaner',
    'AC Repair',
  ];
  static const _ratings = [4.8, 4.6, 4.9, 4.7, 4.5];
  static const _distances = ['1.2 km', '2.4 km', '0.8 km', '3.1 km', '1.5 km'];

  static const _providerIds = ['prov1', 'prov2', 'prov3', 'prov4', 'prov5'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ProviderProfileScreen(providerId: _providerIds[index]),
          ),
        );
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Avatar with online dot
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.primaryLight.withValues(alpha: 0.2),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _names[index][0],
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.online,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isDark ? AppColors.cardDark : AppColors.cardLight,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Name
            Text(
              _names[index],
              style: AppTypography.titleMedium.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 2),

            // Skill badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryTint,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _skills[index],
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),

            // Rating + distance
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: AppColors.starFilled,
                ),
                const SizedBox(width: 3),
                Text(
                  '${_ratings[index]}',
                  style: AppTypography.labelSmall.copyWith(
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _distances[index],
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
      ),
    );
  }
}

// ─── Popular Service Card ───────────────────────────────────────
class _PopularServiceCard extends StatelessWidget {
  final bool isDark;
  final int index;

  const _PopularServiceCard({required this.isDark, required this.index});

  static const _titles = [
    'AC Service & Repair',
    'Full House Cleaning',
    'Electrician Visit',
  ];
  static const _descs = [
    'Gas refill, coil cleaning, general service',
    'Deep cleaning for 2-3 BHK homes',
    'Wiring, switch repair, fan installation',
  ];
  static const _prices = ['₹499', '₹1,299', '₹299'];
  static const _ratings = ['4.8', '4.7', '4.9'];
  static const _icons = [
    Icons.ac_unit_rounded,
    Icons.cleaning_services_rounded,
    Icons.electrical_services_rounded,
  ];
  static const _colors = [
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _colors[index].withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_icons[index], color: _colors[index], size: 28),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titles[index],
                  style: AppTypography.titleLarge.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _descs[index],
                  style: AppTypography.bodySmall.copyWith(
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _prices[index],
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppColors.starFilled,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      _ratings[index],
                      style: AppTypography.labelSmall.copyWith(
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

          // Arrow
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Service Category Data ──────────────────────────────────────
final _serviceCategories = [
  _CategoryData(
    Icons.electrical_services_rounded,
    'Electrical',
    const Color(0xFFD97706),
    199,
    'electrical',
  ),
  _CategoryData(
    Icons.plumbing_rounded,
    'Plumbing',
    const Color(0xFF0891B2),
    249,
    'plumbing',
  ),
  _CategoryData(
    Icons.carpenter_rounded,
    'Carpentry',
    const Color(0xFFB45309),
    299,
    'carpentry',
  ),
  _CategoryData(
    Icons.cleaning_services_rounded,
    'Cleaning',
    const Color(0xFF059669),
    399,
    'cleaning',
  ),
  _CategoryData(
    Icons.ac_unit_rounded,
    'AC Repair',
    const Color(0xFF2563EB),
    499,
    'ac_repair',
  ),
  _CategoryData(
    Icons.format_paint_rounded,
    'Painting',
    const Color(0xFF7C3AED),
    999,
    'painting',
  ),
  _CategoryData(
    Icons.pest_control_rounded,
    'Pest Ctrl',
    const Color(0xFFDC2626),
    599,
    'pest_control',
  ),
  _CategoryData(
    Icons.build_rounded,
    'Appliance',
    const Color(0xFF4338CA),
    349,
    'appliance',
  ),
  _CategoryData(
    Icons.more_horiz_rounded,
    'More',
    const Color(0xFF6B7280),
    0,
    'more',
  ),
];

class _CategoryData {
  final IconData icon;
  final String name;
  final Color color;
  final int startPrice;
  final String categoryId;

  _CategoryData(
    this.icon,
    this.name,
    this.color,
    this.startPrice,
    this.categoryId,
  );
}
