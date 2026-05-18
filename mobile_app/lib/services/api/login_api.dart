import '../api_service.dart';

class LoginApi {
  LoginApi._private();
  static final LoginApi instance = LoginApi._private();

  Future<bool> sendOtp(String phone) async {
    return await ApiService.instance.sendOTP(phone);
  }
}
