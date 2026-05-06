import 'package:flutter/foundation.dart';

class ApiConstants {
  // Use the physical network IP so the app works across emulators and physical devices
  static const String _networkIp = "192.168.100.8";

  static String get baseUrl {
    return "http://$_networkIp:8000";
  }
}
