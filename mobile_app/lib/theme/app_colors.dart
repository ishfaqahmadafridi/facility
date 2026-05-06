// lib/theme/app_colors.dart
// ──────────────────────────────────────────────────────────────────
// Single source of truth for all color tokens.
// Never use Color() directly in widget code — always reference here.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────
  static const Color primary       = Color(0xFF1A56DB); // Trust blue
  static const Color primaryLight  = Color(0xFF3B82F6);
  static const Color primaryDark   = Color(0xFF1E40AF);

  // ── Vertical accents ─────────────────────────────────────────────
  static const Color success       = Color(0xFF057A55); // Medical green (Nurse)
  static const Color danger        = Color(0xFFE02424); // Emergency red (Roadside)
  static const Color warning       = Color(0xFFFF8B00); // Amber (Roadside)
  static const Color info          = Color(0xFF0EA5E9); // Sky blue (Ride)

  // ── Neutral ───────────────────────────────────────────────────────
  static const Color neutral900    = Color(0xFF111827);
  static const Color neutral800    = Color(0xFF1F2937);
  static const Color neutral700    = Color(0xFF374151);
  static const Color neutral600    = Color(0xFF4B5563);
  static const Color neutral500    = Color(0xFF6B7280);
  static const Color neutral400    = Color(0xFF9CA3AF);
  static const Color neutral300    = Color(0xFFD1D5DB);
  static const Color neutral200    = Color(0xFFE5E7EB);
  static const Color neutral100    = Color(0xFFF3F4F6);
  static const Color white         = Color(0xFFFFFFFF);

  // ── Background ────────────────────────────────────────────────────
  static const Color bgDark        = Color(0xFF0F172A);
  static const Color bgCard        = Color(0xFF1E293B);
  static const Color bgInput       = Color(0xFF1E293B);

  // ── Text ──────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textHint      = Color(0xFF6B7280);

  // ── Status pills ─────────────────────────────────────────────────
  static const Color statusRequested   = Color(0xFF6366F1);
  static const Color statusConfirmed   = Color(0xFF057A55);
  static const Color statusInProgress  = Color(0xFFFF8B00);
  static const Color statusCompleted   = Color(0xFF1A56DB);
  static const Color statusCancelled   = Color(0xFFE02424);
}
