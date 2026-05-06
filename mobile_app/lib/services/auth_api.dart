// lib/services/auth_api.dart
// ──────────────────────────────────────────────────────────────────
// API client for Authentication endpoints.

import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/user_model.dart';
import 'token_service.dart';

class AuthApi {
  final ApiClient _client = ApiClient();
  final TokenService _tokenService = TokenService();

  Future<void> requestOtp(String phone) async {
    await _client.post('/auth/request-otp', data: {'phone': phone});
  }

  Future<UserModel> verifyOtp(String phone, String code) async {
    final response = await _client.post(
      '/auth/verify-otp',
      data: {'phone': phone, 'code': code},
    );

    final data = response.data['data'];
    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];
    final userJson = data['user'];

    await _tokenService.saveToken(accessToken);
    await _tokenService.saveRefreshToken(refreshToken);

    return UserModel.fromJson(userJson);
  }

  Future<void> logout() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken != null) {
        await _client.post('/auth/logout', data: {'refresh_token': refreshToken});
      }
    } catch (e) {
      // Ignore errors on logout
    } finally {
      await _tokenService.deleteToken();
      await _tokenService.deleteRefreshToken();
    }
  }
}
