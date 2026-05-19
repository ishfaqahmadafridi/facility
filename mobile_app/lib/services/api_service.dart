import 'dart:convert';
import 'dart:io';

import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';

/// High-level API service — thin wrapper over [ApiClient].
///
/// Each method maps to a single backend endpoint using
/// [ApiEndpoints] constants. No hardcoded URLs or headers here.
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final _client = ApiClient.instance;

  // ── Token passthrough ─────────────────────────────────────────────────────

  String? get authToken => _client.authToken;

  // ── Auth ───────────────────────────────────────────────────────────────────

  Future<bool> sendOTP(String phoneNumber) async {
    final res = await _client.post(
      ApiEndpoints.sendOtp,
      body: {'phone_number': phoneNumber},
      requiresAuth: false,
    );
    return res.statusCode == 200;
  }

  Future<Map<String, dynamic>?> verifyOTP(String phoneNumber, String code) async {
    final res = await _client.post(
      ApiEndpoints.verifyOtp,
      body: {'phone_number': phoneNumber, 'otp_code': code},
      requiresAuth: false,
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _client.setAuthToken(data['tokens']['access']);
      return data;
    }
    return null;
  }

  Future<bool> completeProfile(Map<String, dynamic> profileData) async {
    if (!_client.isAuthenticated) return false;
    final res = await _client.post(ApiEndpoints.completeProfile, body: profileData);
    return res.statusCode == 200;
  }

  Future<bool> completeProfileMultipart(
    Map<String, dynamic> fields,
    Map<String, String> files,
  ) async {
    if (!_client.isAuthenticated) return false;
    final res = await _client.multipartPost(
      ApiEndpoints.completeProfile,
      fields: fields,
      files: files,
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  // ── Mode / Status ──────────────────────────────────────────────────────────

  Future<bool> switchMode(String mode) async {
    if (!_client.isAuthenticated) return false;
    final res = await _client.post(ApiEndpoints.switchMode, body: {'mode': mode});
    return res.statusCode == 200;
  }

  Future<bool> toggleOnline(bool isOnline, {double? lat, double? lng}) async {
    if (!_client.isAuthenticated) return false;
    final body = <String, dynamic>{'is_online': isOnline};
    if (lat != null && lng != null) {
      body['latitude'] = lat;
      body['longitude'] = lng;
    }
    final res = await _client.post(ApiEndpoints.toggleOnline, body: body);
    return res.statusCode == 200;
  }

  Future<bool> toggleRiderMode(bool isRiderMode) async {
    if (!_client.isAuthenticated) return false;
    final res = await _client.post(
      ApiEndpoints.toggleRiderMode,
      body: {'is_rider_mode': isRiderMode},
    );
    return res.statusCode == 200;
  }

  // ── Categories & Providers ─────────────────────────────────────────────────

  Future<List<dynamic>> getCategories() async {
    if (!_client.isAuthenticated) return [];
    try {
      final res = await _client.get(ApiEndpoints.categories);
      if (res.statusCode == 200) return jsonDecode(res.body) ?? [];
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
    if (!_client.isAuthenticated) return [];
    final params = <String, String>{
      'latitude': lat.toString(),
      'longitude': lng.toString(),
      'radius': radius.toString(),
    };
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (womenOnly) params['women_only'] = 'true';

    try {
      final res = await _client.get(ApiEndpoints.providersNearby, queryParams: params);
      if (res.statusCode == 200) return jsonDecode(res.body)['providers'] ?? [];
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>?> getProviderDetails(String providerId) async {
    if (!_client.isAuthenticated) return null;
    try {
      final res = await _client.get(ApiEndpoints.providerDetails(providerId));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> getMyProviderProfile() async {
    if (!_client.isAuthenticated) return null;
    try {
      final res = await _client.get(ApiEndpoints.myProviderProfile);
      if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}
    return null;
  }

  // ── Jobs ───────────────────────────────────────────────────────────────────

  Future<List<dynamic>> getJobs() async {
    if (!_client.isAuthenticated) return [];
    final res = await _client.get(ApiEndpoints.availableJobs);
    if (res.statusCode == 200) return jsonDecode(res.body)['jobs'] ?? [];
    return [];
  }

  Future<bool> createJobBooking(Map<String, dynamic> bookingData) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(ApiEndpoints.createJob, body: bookingData);
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<bool> acceptJob(String jobId) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(ApiEndpoints.acceptJob(jobId));
      return res.statusCode == 200;
    } catch (_) {}
    return false;
  }

  Future<Map<String, dynamic>?> getActiveAssignments() async {
    if (!_client.isAuthenticated) return null;
    try {
      final res = await _client.get(ApiEndpoints.activeJobs);
      if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}
    return null;
  }

  Future<List<dynamic>> getJobHistory() async {
    if (!_client.isAuthenticated) return [];
    try {
      final res = await _client.get(ApiEndpoints.jobHistory);
      if (res.statusCode == 200) return jsonDecode(res.body)['jobs'] ?? [];
    } catch (_) {}
    return [];
  }

  // ── Rides ──────────────────────────────────────────────────────────────────

  Future<bool> createRideRequest(Map<String, dynamic> rideData) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(ApiEndpoints.createRide, body: rideData);
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<List<dynamic>> getAvailableRides() async {
    if (!_client.isAuthenticated) return [];
    try {
      final res = await _client.get(ApiEndpoints.availableRides);
      if (res.statusCode == 200) return jsonDecode(res.body)['rides'] ?? [];
    } catch (_) {}
    return [];
  }

  Future<bool> acceptRide(String rideId) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(ApiEndpoints.acceptRide(rideId));
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<bool> counterOfferRide(String rideId, num amount) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(
        ApiEndpoints.counterOfferRide(rideId),
        body: {'amount': amount},
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<bool> acceptCounterOffer(String rideId) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(ApiEndpoints.acceptCounterOffer(rideId));
      return res.statusCode == 200;
    } catch (_) {}
    return false;
  }

  Future<bool> declineCounterOffer(String rideId) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(ApiEndpoints.declineCounterOffer(rideId));
      return res.statusCode == 200;
    } catch (_) {}
    return false;
  }

  // ── Payments ───────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getWalletSummary() async {
    if (!_client.isAuthenticated) return null;
    try {
      final res = await _client.get(ApiEndpoints.wallet);
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (_) {}
    return null;
  }

  // ── Communication ──────────────────────────────────────────────────────────

  Future<bool> triggerSOS({
    required double latitude,
    required double longitude,
    bool sharedWithPolice = true,
    String notes = '',
  }) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(ApiEndpoints.sos, body: {
        'latitude': latitude,
        'longitude': longitude,
        'shared_with_police': sharedWithPolice,
        'notes': notes,
      });
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {}
    return false;
  }

  Future<List<dynamic>> getChatHistory(String jobId) async {
    if (!_client.isAuthenticated) return [];
    try {
      final res = await _client.get(ApiEndpoints.chatHistory(jobId));
      if (res.statusCode == 200) return jsonDecode(res.body) as List<dynamic>;
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>?> sendTextMessage(String jobId, String content) async {
    if (!_client.isAuthenticated) return null;
    try {
      final res = await _client.post(
        ApiEndpoints.sendMessage(jobId),
        body: {'message_type': 'TEXT', 'content': content},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> sendVoiceNote(String jobId, File file) async {
    if (!_client.isAuthenticated) return null;
    try {
      final res = await _client.multipartFilePost(
        ApiEndpoints.sendMessage(jobId),
        fileField: 'voice_note',
        file: file,
        fields: {'message_type': 'VOICE'},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> getAgoraCallConfig(String jobId) async {
    if (!_client.isAuthenticated) return null;
    try {
      final res = await _client.get(ApiEndpoints.agoraToken(jobId));
      if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}
    return null;
  }

  Future<bool> reportIssue({
    required String jobId,
    required String description,
  }) async {
    if (!_client.isAuthenticated) return false;
    try {
      final res = await _client.post(
        ApiEndpoints.reportIssue(jobId),
        body: {'description': description},
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {}
    return false;
  }
}
