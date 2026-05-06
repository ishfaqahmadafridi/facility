// lib/src/modules/ride/providers/ride_provider.dart
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../../models/ride_model.dart';
import '../../../../models/bid_model.dart';
import '../../../../services/ride_api.dart';
import '../../../../services/websocket_service.dart';

class RideProvider extends ChangeNotifier {
  final RideApi _rideApi = RideApi();
  final WebSocketService _wsService = WebSocketService();

  RideModel? _currentRide;
  RideModel? get currentRide => _currentRide;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<BidModel> _activeBids = [];
  List<BidModel> get activeBids => _activeBids;

  io.Socket? _rideSocket;

  Future<void> initRideSocket() async {
    if (_rideSocket?.connected ?? false) return;

    _rideSocket = await _wsService.initNamespace('ride');
    _rideSocket!.off('new_bid');
    _rideSocket!.on('new_bid', (dynamic payload) {
      final bid = _parseBidFromSocket(payload);
      if (bid != null) {
        addBid(bid);
      }
    });

    _rideSocket!.off('ride_accepted');
    _rideSocket!.on('ride_accepted', (dynamic payload) {
      final rideId = payload is Map ? payload['ride_id']?.toString() : null;
      if (_currentRide != null && rideId == _currentRide!.id) {
        _replaceCurrentRide(status: 'CONFIRMED');
      }
    });

    _rideSocket!.off('ride_status');
    _rideSocket!.on('ride_status', (dynamic payload) {
      if (_currentRide == null || payload is! Map) return;
      final rideId = payload['ride_id']?.toString();
      if (rideId != _currentRide!.id) return;

      final rawPrice = payload['final_price'];
      final finalPrice = rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse(rawPrice?.toString() ?? '');

      _replaceCurrentRide(
        status: payload['status']?.toString() ?? _currentRide!.status,
        driverId: payload['driver_id']?.toString(),
        finalPrice: finalPrice ?? _currentRide!.finalPrice,
      );
    });
  }

  void _replaceCurrentRide({
    String? status,
    String? driverId,
    double? finalPrice,
  }) {
    if (_currentRide == null) return;

    _currentRide = RideModel(
      id: _currentRide!.id,
      customerId: _currentRide!.customerId,
      driverId: driverId ?? _currentRide!.driverId,
      status: status ?? _currentRide!.status,
      rideType: _currentRide!.rideType,
      distanceKm: _currentRide!.distanceKm,
      estimatedPrice: _currentRide!.estimatedPrice,
      finalPrice: finalPrice ?? _currentRide!.finalPrice,
      pickupAddress: _currentRide!.pickupAddress,
      dropoffAddress: _currentRide!.dropoffAddress,
      bids: _currentRide!.bids,
    );
    notifyListeners();
  }

  BidModel? _parseBidFromSocket(dynamic payload) {
    if (payload is! Map) return null;
    final map = Map<String, dynamic>.from(payload);
    final rawAmount = map['bid_amount'];
    final amount = rawAmount is num
        ? rawAmount.toDouble()
        : double.tryParse(rawAmount?.toString() ?? '');
    if (amount == null) return null;

    return BidModel(
      id: map['bid_id']?.toString() ?? '',
      driverId: map['driver_id']?.toString() ?? '',
      bidAmount: amount,
      status: map['status']?.toString() ?? 'PENDING',
    );
  }

  Future<bool> requestRide(Map<String, dynamic> payload) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentRide = await _rideApi.requestRide(payload);
      _activeBids = [];
      await initRideSocket();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> placeBid(double amount) async {
    if (_currentRide == null) return;
    try {
      await _rideApi.placeBid(_currentRide!.id, amount);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> acceptBid(String bidId) async {
    if (_currentRide == null) return false;
    _isLoading = true;
    notifyListeners();
    try {
      _currentRide = await _rideApi.acceptBid(_currentRide!.id, bidId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Called when WS sends a new bid
  void addBid(BidModel bid) {
    final exists = _activeBids.any((existing) => existing.id == bid.id);
    if (exists) return;
    _activeBids.add(bid);
    notifyListeners();
  }

  void clearRide() {
    _currentRide = null;
    _activeBids.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _rideSocket?.off('new_bid');
    _rideSocket?.off('ride_accepted');
    _rideSocket?.off('ride_status');
    _rideSocket?.disconnect();
    _rideSocket = null;
    super.dispose();
  }
}
