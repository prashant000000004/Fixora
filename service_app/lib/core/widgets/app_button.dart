import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

/// Premium animated button with scale-down press effect and optional shimmer.
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool showShimmer;
  final IconData? icon;
  final double? width;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.showShimmer = false,
    this.icon,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown:
          widget.onPressed != null ? (_) => _scaleController.forward() : null,
      onTapUp:
          widget.onPressed != null
              ? (_) {
                _scaleController.reverse();
                widget.onPressed?.call();
              }
              : null,
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: _buildButton(isDark),
      ),
    );
  }

  Widget _buildButton(bool isDark) {
    final bgColor =
        widget.backgroundColor ??
        (isDark ? AppColors.primaryLight : AppColors.primary);
    final fgColor = widget.foregroundColor ?? Colors.white;

    return Container(
      width: widget.width ?? double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient:
            widget.isOutlined
                ? null
                : LinearGradient(
                  colors: [bgColor, bgColor.withValues(alpha: 0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        borderRadius: BorderRadius.circular(14),
        border:
            widget.isOutlined ? Border.all(color: bgColor, width: 1.5) : null,
        boxShadow:
            widget.isOutlined
                ? null
                : [
                  BoxShadow(
                    color: bgColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Shimmer effect
            if (widget.showShimmer && !widget.isLoading)
              _ShimmerOverlay(borderRadius: BorderRadius.circular(14)),

            // Content
            Center(
              child:
                  widget.isLoading
                      ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(fgColor),
                        ),
                      )
                      : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.isOutlined ? bgColor : fgColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: AppTypography.titleLarge.copyWith(
                              color: widget.isOutlined ? bgColor : fgColor,
                            ),
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

/// Animated shimmer overlay that loops on the button.
class _ShimmerOverlay extends StatefulWidget {
  final BorderRadius borderRadius;

  const _ShimmerOverlay({required this.borderRadius});

  @override
  State<_ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<_ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: widget.borderRadius,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
                end: Alignment(0 + 2.0 * _controller.value, 0),
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ).createShader(bounds);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: widget.borderRadius,
              ),
            ),
          ),
        );
      },
    );
  }
}
