// lib/services/websocket_service.dart
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/app_config.dart';
import 'token_service.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  final TokenService _tokenService = TokenService();
  
  // Namespace clients
  IO.Socket? _locationSocket;
  // IO.Socket? _rideSocket;
  // IO.Socket? _bookingSocket;

  WebSocketService._internal();

  /// Initializes a specific namespace socket
  Future<IO.Socket> initNamespace(String namespace) async {
    final token = await _tokenService.getToken();
    if (token == null) throw Exception("No auth token for WebSocket");

    final socketUrl = '${AppConfig.wsUrl}/$namespace';
    
    final socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });

    socket.onConnect((_) {
      print('[WS] Connected to /$namespace');
    });

    socket.onDisconnect((_) {
      print('[WS] Disconnected from /$namespace');
    });

    socket.onError((error) {
      print('[WS] Error on /$namespace: $error');
    });

    socket.connect();
    return socket;
  }

  // ── Location Namespace ───────────────────────────────────────────
  Future<void> connectLocation() async {
    if (_locationSocket?.connected ?? false) return;
    _locationSocket = await initNamespace('location');
  }

  void disconnectLocation() {
    _locationSocket?.disconnect();
    _locationSocket = null;
  }

  void emitLocationUpdate(double lat, double lng, String vertical, double heading) {
    if (_locationSocket == null || !_locationSocket!.connected) return;
    
    _locationSocket!.emit('update_location', {
      'lat': lat,
      'lng': lng,
      'vertical': vertical,
      'heading': heading,
    });
  }

  void emitGetNearby(double lat, double lng, String vertical, double radiusKm) {
    if (_locationSocket == null || !_locationSocket!.connected) return;
    
    _locationSocket!.emit('get_nearby', {
      'lat': lat,
      'lng': lng,
      'vertical': vertical,
      'radius_km': radiusKm,
    });
  }

  void onNearbyProviders(Function(dynamic) callback) {
    _locationSocket?.on('nearby_providers', callback);
  }

  void offNearbyProviders() {
    _locationSocket?.off('nearby_providers');
  }
}
