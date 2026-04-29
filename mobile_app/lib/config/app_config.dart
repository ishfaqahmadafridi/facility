// lib/config/app_config.dart
// ──────────────────────────────────────────────────────────────────
// Environment-based configuration.
// No process.env in service files — always import from here.

class AppConfig {
  AppConfig._();

  // ── Backend ───────────────────────────────────────────────────────
  // Change _networkIp to your machine's local IP for device testing
  static const String _networkIp = "192.168.100.8";
  static const String _localPort = "8000";

  static const String baseUrl      = "http://$_networkIp:$_localPort";
  static const String apiV1        = "$baseUrl/api/v1";
  static const String wsUrl        = "http://$_networkIp:$_localPort";

  // ── Timeouts ──────────────────────────────────────────────────────
  static const int connectTimeoutMs  = 10000;  // 10s
  static const int receiveTimeoutMs  = 15000;  // 15s

  // ── OTP ───────────────────────────────────────────────────────────
  static const int otpLength         = 6;
  static const int otpResendCooldown = 60;     // seconds

  // ── Maps ──────────────────────────────────────────────────────────
  static const String googleMapsApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  // ── Location ──────────────────────────────────────────────────────
  static const int locationUpdateIntervalMs = 4000;  // 4 seconds

  // ── Pagination ────────────────────────────────────────────────────
  static const int defaultPageSize = 20;
}
