// ignore_for_file: avoid_print
import 'dart:io';

class ApiConstants {
  static String get host {
    if (Platform.isAndroid) {
      return '10.0.2.2';
    } else if (Platform.isIOS) {
      return '127.0.0.1';
    }
    return 'localhost';
  }

  static String get baseUrl {
    final url = 'http://$host:8000';
    print('Connecting to Backend at: $url');
    return url;
  }

  static String get wsBaseUrl {
    final url = 'ws://$host:8000';
    print('Connecting to WebSocket Backend at: $url');
    return url;
  }

  static String get apiV1BaseUrl => '$baseUrl/api/v1';
}
