import 'dart:io';

import '../utils/logger.dart';

/// Network configuration — hosts, ports, and base URLs.
///
/// Automatically resolves the correct loopback address for the
/// platform under test (Android emulator vs iOS simulator vs desktop).
class NetworkConfig {
  NetworkConfig._();

  static String get host {
    if (Platform.isAndroid) return '10.0.2.2';
    if (Platform.isIOS) return '127.0.0.1';
    return 'localhost';
  }

  static String get baseUrl {
    final url = 'http://$host:8000';
    AppLogger.d('Connecting to Backend at: $url');
    return url;
  }

  static String get wsBaseUrl {
    final url = 'ws://$host:8000';
    AppLogger.d('Connecting to WebSocket Backend at: $url');
    return url;
  }

  static String get apiV1BaseUrl => '$baseUrl/api/v1';
}
