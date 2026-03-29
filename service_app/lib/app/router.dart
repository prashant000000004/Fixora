import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';

import '../../features/profile/presentation/profile_setup_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/saved_addresses_screen.dart';
import '../../features/profile/presentation/saved_providers_screen.dart';
import '../../features/profile/presentation/notifications_screen.dart';
import '../../features/profile/presentation/support_screen.dart';
import '../../features/profile/presentation/referral_screen.dart';
import '../../features/booking/presentation/my_bookings_screen.dart';
import '../../features/booking/presentation/booking_detail_screen.dart';
import '../../features/booking/presentation/rating_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/booking/presentation/booking_flow_screen.dart';
import '../../features/services/domain/service_models.dart';
import '../../features/provider/presentation/provider_home_screen.dart';
import '../../features/provider/presentation/provider_setup_screen.dart';
import '../../features/provider/presentation/booking_request_screen.dart';
import '../../features/provider/presentation/active_job_screen.dart';
import '../../features/provider/presentation/earnings_screen.dart';
import '../../features/provider/presentation/provider_reviews_screen.dart';
import '../../features/provider/presentation/schedule_management_screen.dart';

/// Route paths
class Routes {
  Routes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';

  static const String profileSetup = '/profile-setup';
  static const String profile = '/profile';
  static const String savedAddresses = '/saved-addresses';
  static const String savedProviders = '/saved-providers';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String referral = '/referral';
  static const String myBookings = '/my-bookings';
  static const String bookingDetail = '/booking-detail/:id';
  static const String rating = '/rating/:id';
  static const String providerSetup = '/provider-setup';
  static const String bookingRequest = '/booking-request';
  static const String activeJob = '/active-job';
  static const String providerEarnings = '/provider-earnings';
  static const String providerReviews = '/provider-reviews';
  static const String providerSchedule = '/provider-schedule';
  static const String home = '/home';
  static const String bookingFlow = '/booking-flow';
  static const String providerHome = '/provider-home';
}

/// GoRouter configuration with custom page transitions.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const SplashScreen(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
      ),
      GoRoute(
        path: Routes.onboarding,
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const OnboardingScreen(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder:
            (context, state) => _slideTransition(state, const LoginScreen()),
      ),

      GoRoute(
        path: Routes.profileSetup,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const ProfileSetupScreen()),
      ),
      GoRoute(
        path: Routes.home,
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
      ),
      GoRoute(
        path: Routes.bookingFlow,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final service = extra['service'] as SubService?;
          final provider = extra['provider'] as ServiceProvider?;
          // Fallback if accessed wrong (shouldn't happen in app flow)
          if (service == null) {
            return _slideTransition(state, const HomeScreen());
          }
          return _slideTransition(
            state,
            BookingFlowScreen(service: service, provider: provider),
          );
        },
      ),
      GoRoute(
        path: Routes.providerHome,
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProviderHomeScreen(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
      ),
      GoRoute(
        path: Routes.profile,
        pageBuilder:
            (context, state) => _slideTransition(state, const ProfileScreen()),
      ),
      GoRoute(
        path: Routes.savedAddresses,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const SavedAddressesScreen()),
      ),
      GoRoute(
        path: Routes.savedProviders,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const SavedProvidersScreen()),
      ),
      GoRoute(
        path: Routes.notifications,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const NotificationsScreen()),
      ),
      GoRoute(
        path: Routes.support,
        pageBuilder:
            (context, state) => _slideTransition(state, const SupportScreen()),
      ),
      GoRoute(
        path: Routes.referral,
        pageBuilder:
            (context, state) => _slideTransition(state, const ReferralScreen()),
      ),
      GoRoute(
        path: Routes.myBookings,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const MyBookingsScreen()),
      ),
      GoRoute(
        path: Routes.bookingDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'unknown';
          return _slideTransition(state, BookingDetailScreen(bookingId: id));
        },
      ),
      GoRoute(
        path: Routes.rating,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'unknown';
          return _slideTransition(state, RatingScreen(bookingId: id));
        },
      ),
      GoRoute(
        path: Routes.providerSetup,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const ProviderSetupScreen()),
      ),
      GoRoute(
        path: Routes.bookingRequest,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const BookingRequestScreen()),
      ),
      GoRoute(
        path: Routes.activeJob,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const ActiveJobScreen()),
      ),
      GoRoute(
        path: Routes.providerEarnings,
        pageBuilder:
            (context, state) => _slideTransition(state, const EarningsScreen()),
      ),
      GoRoute(
        path: Routes.providerReviews,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const ProviderReviewsScreen()),
      ),
      GoRoute(
        path: Routes.providerSchedule,
        pageBuilder:
            (context, state) =>
                _slideTransition(state, const ScheduleManagementScreen()),
      ),
    ],
  );
});

/// Slide-from-right page transition for forward navigation.
CustomTransitionPage _slideTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );
    },
  );
}
