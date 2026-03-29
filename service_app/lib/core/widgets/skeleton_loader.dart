import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer skeleton loader — no spinners in the main flow.
/// Configurable shapes for different content types.
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShapeType shape;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
    this.shape = ShapeType.rectangle,
  });

  /// A text line skeleton
  const SkeletonLoader.line({
    super.key,
    this.width = 200,
    this.height = 14,
    this.borderRadius = 4,
  }) : shape = ShapeType.rectangle;

  /// A circle skeleton (avatar, icon)
  const SkeletonLoader.circle({super.key, double size = 48})
    : width = size,
      height = size,
      borderRadius = 999,
      shape = ShapeType.circle;

  /// A card skeleton
  const SkeletonLoader.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
    this.borderRadius = 16,
  }) : shape = ShapeType.rectangle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8);
    final highlightColor =
        isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius:
              shape == ShapeType.circle
                  ? null
                  : BorderRadius.circular(borderRadius),
          shape:
              shape == ShapeType.circle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

/// A full skeleton card mimicking a service card layout.
class SkeletonServiceCard extends StatelessWidget {
  const SkeletonServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader.card(height: 100),
          SizedBox(height: 12),
          SkeletonLoader.line(width: 160, height: 16),
          SizedBox(height: 8),
          SkeletonLoader.line(width: 100, height: 12),
          SizedBox(height: 12),
          Row(
            children: [
              SkeletonLoader.circle(size: 32),
              SizedBox(width: 8),
              SkeletonLoader.line(width: 80, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

/// A skeleton for provider cards.
class SkeletonProviderCard extends StatelessWidget {
  const SkeletonProviderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          SkeletonLoader.circle(size: 56),
          SizedBox(height: 8),
          SkeletonLoader.line(width: 100, height: 14),
          SizedBox(height: 4),
          SkeletonLoader.line(width: 60, height: 10),
        ],
      ),
    );
  }
}

enum ShapeType { rectangle, circle }
