// lib/src/providers/location_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/location_service.dart';
import '../../services/websocket_service.dart';
import '../../config/app_config.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final WebSocketService _wsService = WebSocketService();

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  StreamSubscription<Position>? _positionSubscription;
  Timer? _broadcastTimer;

  bool _isBroadcasting = false;
  bool get isBroadcasting => _isBroadcasting;

  String? _activeVertical; // e.g., 'RIDE', 'MEDICAL'

  Future<bool> requestPermission() async {
    return await _locationService.handlePermission();
  }

  Future<void> initLocation() async {
    final hasPermission = await requestPermission();
    if (hasPermission) {
      _currentPosition = await _locationService.getCurrentPosition();
      notifyListeners();
    }
  }

  /// Starts actively streaming location to the backend via WebSocket
  Future<void> startBroadcasting(String vertical) async {
    if (_isBroadcasting) return;
    
    _activeVertical = vertical;
    _isBroadcasting = true;
    notifyListeners();

    await _wsService.connectLocation();

    // Start listening to GPS stream
    _positionSubscription = _locationService.getPositionStream()?.listen(
      (Position position) {
        _currentPosition = position;
        notifyListeners();
      },
    );

    // Broadcast position every X seconds to avoid flooding WS
    _broadcastTimer = Timer.periodic(
      const Duration(milliseconds: AppConfig.locationUpdateIntervalMs), 
      (_) {
        if (_currentPosition != null && _activeVertical != null) {
          _wsService.emitLocationUpdate(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            _activeVertical!,
            _currentPosition!.heading,
          );
        }
      }
    );
  }

  /// Stops broadcasting location to the backend
  void stopBroadcasting() {
    if (!_isBroadcasting) return;

    _broadcastTimer?.cancel();
    _broadcastTimer = null;
    
    _positionSubscription?.cancel();
    _positionSubscription = null;
    
    _wsService.disconnectLocation();
    
    _isBroadcasting = false;
    _activeVertical = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopBroadcasting();
    super.dispose();
  }
}
