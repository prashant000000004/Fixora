import 'package:flutter/material.dart';

/// Full color system for the hyperlocal service booking app.
/// Follows "Calm Design" — premium, trustworthy, never overwhelming.
class AppColors {
  AppColors._();

  // ─── Primary ───────────────────────────────────────────────
  static const Color primary = Color(0xFF4F46E5); // Electric Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color primaryTint = Color(0x1A4F46E5); // 10% opacity

  // ─── Surface (Light Mode) ─────────────────────────────────
  static const Color surfaceLight = Color(0xFFF7F8FA);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE5E7EB);

  // ─── Surface (Dark Mode) ──────────────────────────────────
  static const Color surfaceDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color dividerDark = Color(0xFF2D2D2D);

  // ─── Semantic Colors ──────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successTint = Color(0x1A10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningTint = Color(0x1AF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorTint = Color(0x1AEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoTint = Color(0x1A3B82F6);

  // ─── Text Colors (Light Mode) ─────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  // ─── Text Colors (Dark Mode) ──────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);

  // ─── Service Category Pastel Tints ────────────────────────
  static const Color electricalTint = Color(0xFFFFF3CD);
  static const Color plumbingTint = Color(0xFFD1ECF1);
  static const Color carpentryTint = Color(0xFFFDE2D2);
  static const Color cleaningTint = Color(0xFFD4EDDA);
  static const Color acRepairTint = Color(0xFFCCE5FF);
  static const Color paintingTint = Color(0xFFE8DAEF);

  // ─── Star Rating ──────────────────────────────────────────
  static const Color starFilled = Color(0xFFFBBF24);
  static const Color starEmpty = Color(0xFFD1D5DB);

  // ─── Online Status ────────────────────────────────────────
  static const Color online = Color(0xFF22C55E);
  static const Color offline = Color(0xFF9CA3AF);

  // ─── Booking Status Colors ────────────────────────────────
  static const Color statusUpcoming = Color(0xFFF59E0B);
  static const Color statusOngoing = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFFEF4444);
}
