import 'package:flutter/material.dart';
import '../../../../services/api_client.dart';
import '../../../../services/websocket_service.dart';

class RoadsideProvider extends ChangeNotifier {
  final ApiClient _client = ApiClient();
  final WebSocketService _wsService = WebSocketService();

  Map<String, dynamic>? _currentRequest;
  Map<String, dynamic>? get currentRequest => _currentRequest;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> requestAssistance(String issueType, String address, double lat, double lng) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _client.post('/roadside', data: {
        'issue_type': issueType,
        'address': address,
        'lat': lat,
        'lng': lng,
      });
      _currentRequest = response.data;
      
      // Connect to booking namespace to listen for 'booking_accepted'
      await _wsService.initNamespace('booking');
      
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
