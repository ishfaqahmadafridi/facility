import '../../../services/api/login_api.dart';

class LoginController {
  Future<bool> sendOtp(String phone) async {
    return await LoginApi.instance.sendOtp(phone);
  }
}
