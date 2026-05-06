// lib/src/modules/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../../../../services/auth_api.dart';
import '../../../../models/user_model.dart';
import '../../../../services/token_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final TokenService _tokenService = TokenService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _currentPhone;
  String? get currentPhone => _currentPhone;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> checkAuthStatus() async {
    final token = await _tokenService.getToken();
    _isAuthenticated = token != null && token.isNotEmpty;
    notifyListeners();
    return _isAuthenticated;
  }

  Future<bool> requestOtp(String phone) async {
    _setLoading(true);
    try {
      await _authApi.requestOtp(phone);
      _currentPhone = phone;
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<UserModel?> verifyOtp(String code) async {
    if (_currentPhone == null) {
      _setError("Phone number not found. Please try again.");
      return null;
    }

    _setLoading(true);
    try {
      final user = await _authApi.verifyOtp(_currentPhone!, code);
      if (user != null) {
        _isAuthenticated = true;
      }
      return user;
    } catch (e) {
      _setError("Invalid OTP or expired.");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await _authApi.logout();
    _currentPhone = null;
    _isAuthenticated = false;
    _setLoading(false);
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
