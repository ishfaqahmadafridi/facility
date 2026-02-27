import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; // Android Emulator address

  Future<bool> requestOtp(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/request-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    return response.statusCode == 200;
  }

  Future<String?> verifyOtp(String email, String code) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/verify-otp?email=$email&code=$code"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    }
    return null;
  }

  Future<List<dynamic>> getJobs() async {
    final response = await http.get(Uri.parse("$baseUrl/feed/jobs"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
