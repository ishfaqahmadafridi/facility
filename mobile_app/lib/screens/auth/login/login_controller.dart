import 'package:facility/services/api_service.dart';

/// Controller for the login flow — calls [ApiService] directly.
class LoginController {
  Future<bool> sendOtp(String phone) async {
    return ApiService.instance.sendOTP(phone);
  }
}
