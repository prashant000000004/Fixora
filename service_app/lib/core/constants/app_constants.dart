/// App-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'FixNow';
  static const String appTagline = 'Expert services at your doorstep';
  static const int otpLength = 6;
  static const int otpResendSeconds = 30;
  static const int maxScheduleDays = 7;
  static const double nearbyRadiusKm = 5.0;
  static const int providerAcceptTimeoutSeconds = 15;
  static const int gpsUpdateIntervalSeconds = 4;

  // Shared Preferences keys
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyUserRole = 'user_role';
}
