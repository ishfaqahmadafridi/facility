/// Custom exception hierarchy for the KamKaro app.
class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException: $message (status: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException([String message = 'Network error'])
      : super(message);
}

class AuthException extends AppException {
  const AuthException([String message = 'Authentication required'])
      : super(message);
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}
