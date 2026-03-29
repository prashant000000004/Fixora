import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system — two fonts, used with intention.
/// Headings: DM Sans (geometric, confident)
/// Body: Inter (most readable at small sizes)
class AppTypography {
  AppTypography._();

  // ─── Heading Styles (DM Sans) ─────────────────────────────
  static TextStyle displayLarge = GoogleFonts.dmSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static TextStyle headlineLarge = GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle headlineMedium = GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle headlineSmall = GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle titleLarge = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle titleMedium = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ─── Body Styles (Inter) ──────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ─── Label / Caption ─────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ─── Key Numbers (DM Sans — bold, large) ──────────────────
  static TextStyle numberLarge = GoogleFonts.dmSans(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  static TextStyle numberMedium = GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle numberSmall = GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Build a full TextTheme for ThemeData.
  static TextTheme textTheme(Color textPrimary, Color textSecondary) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: textPrimary),
      displayMedium: displayMedium.copyWith(color: textPrimary),
      headlineLarge: headlineLarge.copyWith(color: textPrimary),
      headlineMedium: headlineMedium.copyWith(color: textPrimary),
      headlineSmall: headlineSmall.copyWith(color: textPrimary),
      titleLarge: titleLarge.copyWith(color: textPrimary),
      titleMedium: titleMedium.copyWith(color: textPrimary),
      bodyLarge: bodyLarge.copyWith(color: textPrimary),
      bodyMedium: bodyMedium.copyWith(color: textSecondary),
      bodySmall: bodySmall.copyWith(color: textSecondary),
      labelLarge: labelLarge.copyWith(color: textPrimary),
      labelMedium: labelMedium.copyWith(color: textSecondary),
      labelSmall: labelSmall.copyWith(color: textSecondary),
    );
  }
}
