import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class ApiService {
  static String get baseUrl => ApiConstants.apiV1BaseUrl;
  
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();
  
  String? authToken;

  Map<String, String> get _authHeaders => {
        'Authorization': 'Bearer $authToken'
      };

  Map<String, String> get _jsonAuthHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      };

  Future<bool> sendOTP(String phoneNumber) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/auth/send-otp/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone_number": phoneNumber}),
    );
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> verifyOTP(String phoneNumber, String code) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/auth/verify-otp/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone_number": phoneNumber, 'otp_code': code}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      authToken = data['tokens']['access'];
      return data;
    }
    return null;
  }

  Future<bool> completeProfile(Map<String, dynamic> profileData) async {
    if (authToken == null) return false;
    final response = await http.post(
      Uri.parse('$baseUrl/users/profile/complete/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: jsonEncode(profileData),
    );
    return response.statusCode == 200;
  }

  // Use multipart request to upload pictures and fields
  Future<bool> completeProfileMultipart(Map<String, dynamic> fields, Map<String, String> files) async {
    if (authToken == null) return false;
    var uri = Uri.parse('$baseUrl/users/profile/complete/');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $authToken';
    
    // Add text fields
    fields.forEach((key, value) {
      if (value is List) {
        for (var i = 0; i < value.length; i++) {
          request.fields['$key[$i]'] = value[i].toString();
        }
      } else {
        request.fields[key] = value.toString();
      }
    });

    // Add files
    for (var entry in files.entries) {
      if (entry.value.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
      }
    }

    var response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }


  Future<List<dynamic>> getJobs() async {
    final response = await http.get(Uri.parse("$baseUrl/jobs/available/"), headers: _authHeaders);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['jobs'] ?? [];
    }
    return [];
  }

  Future<bool> switchMode(String mode) async {
    if (authToken == null) return false;
    final response = await http.post(
      Uri.parse('$baseUrl/users/switch-mode/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: jsonEncode({'mode': mode}),
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getCategories() async {
    if (authToken == null) return [];
    try {
      final response = await http.get(Uri.parse("$baseUrl/jobs/categories/"), headers: {
        'Authorization': 'Bearer $authToken'
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body) ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<List<dynamic>> getProvidersNearby({
    required double lat,
    required double lng,
    double radius = 10.0,
    String? category,
    bool womenOnly = false,
  }) async {
    if (authToken == null) return [];
    
    // Construct query parameters
    final Map<String, String> queryParams = {
      'latitude': lat.toString(),
      'longitude': lng.toString(),
      'radius': radius.toString(),
    };
    
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (womenOnly) {
      queryParams['women_only'] = 'true';
    }
    
    final uri = Uri.parse("$baseUrl/jobs/providers-nearby/").replace(queryParameters: queryParams);
    
    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $authToken'
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['providers'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<bool> toggleOnline(bool isOnline, {double? lat, double? lng}) async {
    if (authToken == null) return false;
    final Map<String, dynamic> body = {'is_online': isOnline};
    if (lat != null && lng != null) {
      body['latitude'] = lat;
      body['longitude'] = lng;
    }
    final response = await http.post(
      Uri.parse('$baseUrl/users/toggle-online/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  Future<bool> toggleRiderMode(bool isRiderMode) async {
    if (authToken == null) return false;
    final response = await http.post(
      Uri.parse('$baseUrl/users/toggle-rider-mode/'),
      headers: _jsonAuthHeaders,
      body: jsonEncode({'is_rider_mode': isRiderMode}),
    );
    return response.statusCode == 200;
  }

  Future<bool> triggerSOS({
    required double latitude,
    required double longitude,
    bool sharedWithPolice = true,
    String notes = '',
  }) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/communication/sos/'),
        headers: _jsonAuthHeaders,
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'shared_with_police': sharedWithPolice,
          'notes': notes,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<Map<String, dynamic>?> getWalletSummary() async {
    if (authToken == null) return null;
    try {
      final response = await http.get(Uri.parse("$baseUrl/payments/wallet/"), headers: {
        'Authorization': 'Bearer $authToken'
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> getProviderDetails(String providerId) async {
    if (authToken == null) return null;
    try {
      final response = await http.get(Uri.parse("$baseUrl/users/providers/$providerId/"), headers: {
        'Authorization': 'Bearer $authToken'
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (_) {}
    return null;
  }

  Future<bool> createJobBooking(Map<String, dynamic> bookingData) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/create/'),
        headers: _jsonAuthHeaders,
        body: jsonEncode(bookingData),
      );
      // Status 200/201 means Escrow hit was successful/booked
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {}
    return false;
  }

  // --- Rides & Transport Endpoints ---
  Future<bool> createRideRequest(Map<String, dynamic> rideData) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/rides/create/'),
        headers: _jsonAuthHeaders,
        body: jsonEncode(rideData),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<List<dynamic>> getAvailableRides() async {
    if (authToken == null) return [];
    try {
      final response = await http.get(Uri.parse("$baseUrl/jobs/rides/available/"), headers: _authHeaders);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['rides'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<bool> acceptRide(String rideId) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/rides/$rideId/accept/'),
        headers: _jsonAuthHeaders,
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<bool> counterOfferRide(String rideId, num amount) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/rides/$rideId/offer/'),
        headers: _jsonAuthHeaders,
        body: jsonEncode({'amount': amount}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<bool> acceptCounterOffer(String rideId) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/rides/$rideId/accept-counter/'),
        headers: _jsonAuthHeaders,
      );
      return response.statusCode == 200;
    } catch (_) {}
    return false;
  }

  Future<bool> declineCounterOffer(String rideId) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/rides/$rideId/decline-counter/'),
        headers: _jsonAuthHeaders,
      );
      return response.statusCode == 200;
    } catch (_) {}
    return false;
  }

  Future<bool> acceptJob(String jobId) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/$jobId/accept/'),
        headers: _jsonAuthHeaders,
      );
      return response.statusCode == 200;
    } catch (_) {}
    return false;
  }

  Future<Map<String, dynamic>?> getActiveAssignments() async {
    if (authToken == null) return null;
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobs/active/'), headers: _authHeaders);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<List<dynamic>> getJobHistory() async {
    if (authToken == null) return [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobs/history/'), headers: _authHeaders);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['jobs'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<bool> reportIssue({
    required String jobId,
    required String description,
  }) async {
    if (authToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/communication/job/$jobId/report/'),
        headers: _jsonAuthHeaders,
        body: jsonEncode({'description': description}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<Map<String, dynamic>?> getMyProviderProfile() async {
    if (authToken == null) return null;
    try {
      final response = await http.get(Uri.parse("$baseUrl/users/provider/me/"), headers: _authHeaders);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<List<dynamic>> getChatHistory(String jobId) async {
    if (authToken == null) return [];
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/communication/$jobId/messages/'),
        headers: _authHeaders,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>?> sendTextMessage(String jobId, String content) async {
    if (authToken == null) return null;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/communication/$jobId/send/'),
        headers: _jsonAuthHeaders,
        body: jsonEncode({
          'message_type': 'TEXT',
          'content': content,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> sendVoiceNote(String jobId, File file) async {
    if (authToken == null) return null;
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/communication/$jobId/send/'),
      );
      request.headers['Authorization'] = 'Bearer $authToken';
      request.fields['message_type'] = 'VOICE';
      request.files.add(await http.MultipartFile.fromPath('voice_note', file.path));
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> getAgoraCallConfig(String jobId) async {
    if (authToken == null) return null;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/communication/$jobId/agora-token/'),
        headers: _authHeaders,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }
}
