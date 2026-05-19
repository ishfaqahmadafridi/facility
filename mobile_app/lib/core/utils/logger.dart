import 'dart:developer' as developer;

/// Structured logger replacing raw `print()` calls.
class AppLogger {
  AppLogger._();

  static void d(String message) {
    developer.log(message, name: 'KamKaro');
  }

  static void e(String message, [Object? error, StackTrace? stack]) {
    developer.log(message, name: 'KamKaro', error: error, stackTrace: stack);
  }
}
