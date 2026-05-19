/// Application-wide constants.
///
/// Centralises every magic number and default value used across the app
/// so nothing is ever hardcoded inside widgets or services.
class AppConstants {
  AppConstants._();

  // ── App Identity ──────────────────────────────────────────────────────────
  static const String appName = 'KamKaro';
  static const String appTagline = 'Hyper-local services at your fingertips';

  // ── Default Location (Islamabad) ──────────────────────────────────────────
  static const double defaultLatitude = 33.6844;
  static const double defaultLongitude = 73.0479;
  static const String defaultLocationLabel = 'Islamabad';

  // ── Radius & Filters ─────────────────────────────────────────────────────
  static const double defaultRadius = 10.0;
  static const double providerDefaultRadius = 15.0;
  static const List<double> radiusOptions = [5.0, 15.0, 30.0];

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const int otpLength = 6;
  static const int minPhoneLength = 10;
  static const String pakistanCountryCode = '+92';

  // ── Provider Categories ───────────────────────────────────────────────────
  static const List<String> availableCategories = [
    'Plumber',
    'Electrician',
    'Labour',
    'Driver',
    'Nurse',
  ];
}
