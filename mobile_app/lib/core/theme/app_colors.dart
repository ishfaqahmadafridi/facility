import 'package:flutter/material.dart';

/// Centralised colour palette for the KamKaro app.
///
/// Using a single palette ensures visual consistency and makes
/// theme changes trivial — edit here, reflect everywhere.
class AppColors {
  AppColors._();

  // ── Brand / Mode Colours ──────────────────────────────────────────────────
  static const Color customerPrimary = Colors.blueAccent;
  static const Color providerPrimary = Colors.green;

  // ── Semantic Colours ──────────────────────────────────────────────────────
  static const Color danger = Colors.red;
  static const Color warning = Colors.orange;
  static const Color success = Colors.green;
  static const Color info = Colors.blue;

  // ── Surface & Background ──────────────────────────────────────────────────
  static const Color scaffoldBackground = Colors.white;
  static const Color cardBackground = Colors.white;
  static Color surfaceLight = Colors.grey.shade100;
  static Color dividerColor = Colors.grey.shade200;

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textHint = Colors.grey;
  static const Color textOnPrimary = Colors.white;
  static const Color textOnPrimaryFaded = Colors.white70;

  // ── Earnings / Wallet ──────────────────────────────────────────────────────
  static const MaterialColor earningsActive = Colors.green;
  static const MaterialColor earningsEscrow = Colors.orange;
  static const MaterialColor earningsAllTime = Colors.blue;

  // ── Call Screen ────────────────────────────────────────────────────────────
  static const Color callBackground = Color(0xFF0F172A);
  static const Color callSurface = Color(0xFF1E293B);
}
