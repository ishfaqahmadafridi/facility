// lib/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display ───────────────────────────────────────────────────────
  static const TextStyle display1 = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.2,
  );
  static const TextStyle display2 = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.2,
  );

  // ── Headings ──────────────────────────────────────────────────────
  static const TextStyle h1 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.3,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, height: 1.3,
  );
  static const TextStyle h3 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, height: 1.4,
  );

  // ── Body ──────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, height: 1.5,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, height: 1.5,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, height: 1.5,
  );
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, height: 1.5,
  );

  // ── Label ─────────────────────────────────────────────────────────
  static const TextStyle label = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, height: 1.4,
    letterSpacing: 0.3,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, height: 1.4,
    letterSpacing: 0.5,
  );

  // ── Button ────────────────────────────────────────────────────────
  static const TextStyle button = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.white, height: 1.0,
    letterSpacing: 0.3,
  );
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.white, height: 1.0,
  );

  // ── Price (large numbers) ─────────────────────────────────────────
  static const TextStyle price = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w800,
    color: AppColors.primary, height: 1.0,
    letterSpacing: -0.5,
  );
}
