import '../../../../../services/api_service.dart';

class LoginController {
  Future<bool> sendOtp(String phone) async {
    return await ApiService.instance.sendOTP(phone);
  }
}
