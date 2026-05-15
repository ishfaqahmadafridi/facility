import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    String host;
    if (Platform.isAndroid) {
      host = "10.0.2.2";
    } else if (Platform.isIOS) {
      host = "127.0.0.1";
    } else {
      host = "localhost";
    }

    final url = "http://$host:8000";
    // This will help you see the address in your terminal/debug console
    print("Connecting to Backend at: $url");
    return url;
  }
}
