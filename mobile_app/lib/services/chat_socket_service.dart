import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'api_constants.dart';

class ChatSocketService {
  WebSocketChannel? _channel;

  Stream<Map<String, dynamic>> connect({
    required String jobId,
    required String token,
  }) {
    final uri = Uri.parse('${ApiConstants.wsBaseUrl}/ws/chat/$jobId/?token=$token');
    _channel = WebSocketChannel.connect(uri);
    return _channel!.stream.map((event) {
      final data = jsonDecode(event as String) as Map<String, dynamic>;
      return (data['message'] as Map?)?.cast<String, dynamic>() ?? data;
    });
  }

  void sendTextMessage(String content) {
    _channel?.sink.add(jsonEncode({
      'type': 'text_message',
      'content': content,
    }));
  }

  Future<void> dispose() async {
    await _channel?.sink.close();
    _channel = null;
  }
}
