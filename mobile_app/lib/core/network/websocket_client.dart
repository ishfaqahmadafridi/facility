import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'network_config.dart';

/// WebSocket client for real-time chat communication.
///
/// Connects to the Django Channels backend and provides a typed
/// stream of incoming messages.
class WebSocketClient {
  WebSocketChannel? _channel;

  /// Opens a WebSocket connection for the given [jobId].
  ///
  /// Returns a broadcast stream of parsed message maps.
  Stream<Map<String, dynamic>> connect({
    required String jobId,
    required String token,
  }) {
    final uri = Uri.parse(
      '${NetworkConfig.wsBaseUrl}/ws/chat/$jobId/?token=$token',
    );
    _channel = WebSocketChannel.connect(uri);

    return _channel!.stream.map((event) {
      final data = jsonDecode(event as String) as Map<String, dynamic>;
      return (data['message'] as Map?)?.cast<String, dynamic>() ?? data;
    });
  }

  /// Sends a text message over the open socket.
  void sendTextMessage(String content) {
    _channel?.sink.add(jsonEncode({
      'type': 'text_message',
      'content': content,
    }));
  }

  /// Closes the WebSocket connection and releases resources.
  Future<void> dispose() async {
    await _channel?.sink.close();
    _channel = null;
  }
}
