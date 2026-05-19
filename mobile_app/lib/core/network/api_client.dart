import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'network_config.dart';

/// Low-level HTTP client with built-in auth header injection.
///
/// All API calls go through this class so auth, headers, and base URL
/// are managed in exactly one place.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  String? _authToken;

  // ── Token Management ──────────────────────────────────────────────────────

  String? get authToken => _authToken;

  void setAuthToken(String token) => _authToken = token;

  void clearAuthToken() => _authToken = null;

  bool get isAuthenticated => _authToken != null;

  // ── Headers ────────────────────────────────────────────────────────────────

  Map<String, String> get _authHeaders => {
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  Map<String, String> get _jsonAuthHeaders => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // ── Convenience Builders ──────────────────────────────────────────────────

  Uri _uri(String path, [Map<String, String>? queryParams]) {
    final base = Uri.parse('${NetworkConfig.apiV1BaseUrl}$path');
    return queryParams != null
        ? base.replace(queryParameters: queryParams)
        : base;
  }

  // ── HTTP Methods ──────────────────────────────────────────────────────────

  /// GET with auth headers. Returns decoded JSON or `null` on failure.
  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    return http.get(_uri(path, queryParams), headers: _authHeaders);
  }

  /// POST with JSON body and auth headers.
  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return http.post(
      _uri(path),
      headers: requiresAuth ? _jsonAuthHeaders : {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// Multipart POST — for file uploads with text fields.
  Future<http.StreamedResponse> multipartPost(
    String path, {
    required Map<String, dynamic> fields,
    Map<String, String> files = const {},
  }) async {
    final request = http.MultipartRequest('POST', _uri(path));
    if (_authToken != null) {
      request.headers['Authorization'] = 'Bearer $_authToken';
    }

    // Text fields
    fields.forEach((key, value) {
      if (value is List) {
        for (var i = 0; i < value.length; i++) {
          request.fields['$key[$i]'] = value[i].toString();
        }
      } else {
        request.fields[key] = value.toString();
      }
    });

    // File attachments
    for (final entry in files.entries) {
      if (entry.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value),
        );
      }
    }

    return request.send();
  }

  /// Multipart POST for a single file with extra fields (e.g. voice notes).
  Future<http.Response> multipartFilePost(
    String path, {
    required String fileField,
    required File file,
    Map<String, String> fields = const {},
  }) async {
    final request = http.MultipartRequest('POST', _uri(path));
    if (_authToken != null) {
      request.headers['Authorization'] = 'Bearer $_authToken';
    }
    request.fields.addAll(fields);
    request.files.add(
      await http.MultipartFile.fromPath(fileField, file.path),
    );
    final streamed = await request.send();
    return http.Response.fromStream(streamed);
  }
}
