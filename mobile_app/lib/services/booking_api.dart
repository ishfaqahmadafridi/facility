// lib/services/booking_api.dart
import 'api_client.dart';
import '../models/booking_model.dart';

class BookingApi {
  final ApiClient _client = ApiClient();

  Future<BookingModel> requestBooking(Map<String, dynamic> data) async {
    final response = await _client.post('/bookings', data: data);
    return BookingModel.fromJson(response.data);
  }

  Future<BookingModel> getBooking(String bookingId) async {
    final response = await _client.get('/bookings/$bookingId');
    return BookingModel.fromJson(response.data);
  }

  Future<BookingModel> acceptBooking(String bookingId) async {
    final response = await _client.post('/bookings/$bookingId/accept');
    return BookingModel.fromJson(response.data);
  }

  Future<BookingModel> updateStatus(String bookingId, String status) async {
    final response = await _client.patch('/bookings/$bookingId/status', data: {'status': status});
    return BookingModel.fromJson(response.data);
  }
}
