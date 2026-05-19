import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralised text styles.
///
/// Instead of defining `TextStyle(fontSize: 20, fontWeight: FontWeight.bold)`
/// inline in every widget, reference `AppTextStyles.heading` etc.
class AppTextStyles {
  AppTextStyles._();

  // ── Headings ───────────────────────────────────────────────────────────────
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ── Body ───────────────────────────────────────────────────────────────────
  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // ── Captions & Labels ─────────────────────────────────────────────────────
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textHint,
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appBarSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textOnPrimaryFaded,
  );

  static const TextStyle badgeLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );

  // ── Buttons ────────────────────────────────────────────────────────────────
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // ── Earnings ───────────────────────────────────────────────────────────────
  static const TextStyle earningsAmount = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle earningsLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
}
