// lib/src/modules/booking/providers/booking_provider.dart
import 'package:flutter/material.dart';
import '../../../../models/booking_model.dart';
import '../../../../services/booking_api.dart';
import '../../../../services/websocket_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingApi _bookingApi = BookingApi();
  final WebSocketService _wsService = WebSocketService();

  BookingModel? _currentBooking;
  BookingModel? get currentBooking => _currentBooking;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> initBookingSocket() async {
    final socket = await _wsService.initNamespace('booking');
    socket.on('booking_status_update', (data) {
      if (_currentBooking != null && _currentBooking!.id == data['booking_id']) {
        // In a real app we'd fetch the latest booking or just update status
        fetchBooking(_currentBooking!.id);
      }
    });
    socket.on('booking_accepted', (data) {
      if (_currentBooking != null && _currentBooking!.id == data['booking_id']) {
        fetchBooking(_currentBooking!.id);
      }
    });
  }

  Future<void> fetchBooking(String bookingId) async {
    try {
      _currentBooking = await _bookingApi.getBooking(bookingId);
      notifyListeners();
    } catch (e) {
      // ignore
    }
  }

  Future<bool> requestBooking(Map<String, dynamic> payload) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentBooking = await _bookingApi.requestBooking(payload);
      await initBookingSocket();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> acceptBooking(String bookingId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentBooking = await _bookingApi.acceptBooking(bookingId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearBooking() {
    _currentBooking = null;
    notifyListeners();
  }
}
