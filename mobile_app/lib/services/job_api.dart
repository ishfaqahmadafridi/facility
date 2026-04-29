import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

import '../models/job_model.dart';
import 'token_service.dart';

class JobApi {
  final TokenService _tokenService = TokenService();

  Future<List<JobModel>> getJobs() async {
    try {
      final url = "${ApiConstants.baseUrl}/feed/jobs";
      final uri = Uri.parse(url);
      final token = await _tokenService.getToken();

      final resp = await http.get(
        uri,
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ).timeout(const Duration(seconds: 5));

      if (resp.statusCode == 200) {
        final List<dynamic> data = jsonDecode(resp.body);
        return data.map((e) => JobModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load jobs: Server returned ${resp.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Is your backend running?');
    } catch (e) {
      throw Exception('Connection or parsing error: $e');
    }
  }
}
