import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/empty_state_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_1',
      'title': 'Booking Confirmed!',
      'message':
          'Your booking for AC Repair has been confirmed for Today, 2:00 PM.',
      'time': '10 mins ago',
      'type': 'booking',
      'isRead': false,
    },
    {
      'id': 'notif_2',
      'title': 'Provider On The Way',
      'message': 'Rahul Sharma is on the way to your location. ETA: 15 mins.',
      'time': '2 hours ago',
      'type': 'status',
      'isRead': false,
    },
    {
      'id': 'notif_3',
      'title': 'Payment Successful',
      'message': 'Your cash payment of ₹450 for Plumbing service was recorded.',
      'time': 'Yesterday',
      'type': 'payment',
      'isRead': true,
    },
    {
      'id': 'notif_4',
      'title': 'Special Offer!',
      'message':
          'Get 20% off on your next Deep Cleaning booking. Use code CLEAN20.',
      'time': '2 days ago',
      'type': 'promo',
      'isRead': true,
    },
  ];

  IconData _getIconForType(String type) {
    switch (type) {
      case 'booking':
        return Icons.event_available_rounded;
      case 'status':
        return Icons.directions_car_rounded;
      case 'payment':
        return Icons.payments_rounded;
      case 'promo':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['isRead'] = true;
      }
    });
    AppSnackBar.success(context, 'All notifications marked as read');
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
          'Notifications',
          style: AppTypography.headlineMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
            onPressed: _markAllAsRead,
          ),
        ],
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
          _notifications.isEmpty
              ? const EmptyStateWidget(
                icon: Icons.notifications_off_outlined,
                title: 'No notifications yet',
                subtitle:
                    'We\'ll notify you about bookings, offers, and updates',
              )
              : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return _buildNotificationCard(
                    context,
                    isDark,
                    notification,
                    index,
                  );
                },
              ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    bool isDark,
    Map<String, dynamic> notification,
    int index,
  ) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;
    final notifId = notification['id'] as String;

    return Dismissible(
      key: ValueKey(notifId),
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
        setState(() => _notifications.removeAt(index));
        AppSnackBar.info(context, 'Notification dismissed');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isRead
                    ? (isDark ? AppColors.dividerDark : AppColors.dividerLight)
                    : AppColors.primary.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            if (!isRead) {
              setState(() => notification['isRead'] = true);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isRead
                          ? (isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight)
                          : AppColors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(type),
                  color:
                      isRead ? AppColors.textSecondaryLight : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] as String,
                            style: AppTypography.titleMedium.copyWith(
                              color:
                                  isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                              fontWeight:
                                  isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'] as String,
                      style: AppTypography.bodySmall.copyWith(
                        color:
                            isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification['time'] as String,
                      style: AppTypography.labelSmall.copyWith(
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
          ),
        ),
      ),
    );
  }
}
