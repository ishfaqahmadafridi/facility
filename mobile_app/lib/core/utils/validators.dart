/// Input validators used across auth and signup flows.
///
/// Pure functions — no Flutter dependency, easily unit-testable.
class Validators {
  Validators._();

  static bool isValidPhone(String phone) {
    if (phone.isEmpty || phone.length < 10) return false;
    return RegExp(r'^(\+92|0)?3\d{9}$').hasMatch(phone.replaceAll(' ', ''));
  }

  static bool isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }

  static bool isValidCnic(String cnic) {
    final cleaned = cnic.replaceAll('-', '');
    return cleaned.length == 13 && RegExp(r'^\d{13}$').hasMatch(cleaned);
  }

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
