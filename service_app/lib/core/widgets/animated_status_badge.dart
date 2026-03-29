import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

/// Animated status badge with color-coded pill style.
class AnimatedStatusBadge extends StatelessWidget {
  final String text;
  final StatusType status;
  final bool pulsing;

  const AnimatedStatusBadge({
    super.key,
    required this.text,
    required this.status,
    this.pulsing = false,
  });

  Color get _color {
    switch (status) {
      case StatusType.upcoming:
        return AppColors.statusUpcoming;
      case StatusType.ongoing:
        return AppColors.statusOngoing;
      case StatusType.completed:
        return AppColors.statusCompleted;
      case StatusType.cancelled:
        return AppColors.statusCancelled;
      case StatusType.online:
        return AppColors.online;
      case StatusType.offline:
        return AppColors.offline;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTypography.labelMedium.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (pulsing) {
      return _PulsingBadge(color: _color, child: badge);
    }
    return badge;
  }
}

class _PulsingBadge extends StatefulWidget {
  final Color color;
  final Widget child;

  const _PulsingBadge({required this.color, required this.child});

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

enum StatusType { upcoming, ongoing, completed, cancelled, online, offline }
