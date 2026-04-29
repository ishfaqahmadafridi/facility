// lib/services/api_client.dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'token_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  final TokenService _tokenService = TokenService();

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiV1,
      connectTimeout: const Duration(milliseconds: AppConfig.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeoutMs),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Handle 401 token refresh here in the future
        if (e.response?.statusCode == 401) {
          // Token expired logic
        }
        return handler.next(e);
      },
    ));
  }

  // Common GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  // Common POST request
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await dio.post(path, data: data, queryParameters: queryParameters);
  }

  // Common PUT request
  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  // Common DELETE request
  Future<Response> delete(String path, {dynamic data}) async {
    return await dio.delete(path, data: data);
  }

  // Common PATCH request
  Future<Response> patch(String path, {dynamic data}) async {
    return await dio.patch(path, data: data);
  }
}
