// lib/services/ride_api.dart
import 'api_client.dart';
import '../models/ride_model.dart';

class RideApi {
  final ApiClient _client = ApiClient();

  Future<RideModel> requestRide(Map<String, dynamic> data) async {
    final response = await _client.post('/rides', data: data);
    return RideModel.fromJson(response.data);
  }

  Future<RideModel> getRide(String rideId) async {
    final response = await _client.get('/rides/$rideId');
    return RideModel.fromJson(response.data);
  }

  Future<void> placeBid(String rideId, double bidAmount) async {
    await _client.post('/rides/bids', data: {
      'ride_id': rideId,
      'bid_amount': bidAmount,
    });
  }

  Future<RideModel> acceptBid(String rideId, String bidId) async {
    final response = await _client.post('/rides/$rideId/bids/$bidId/accept');
    return RideModel.fromJson(response.data);
  }
}
