import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:facility/services/api_service.dart';
import '../../../core/network/websocket_client.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'utils/audio_manager.dart';

/// Controller for JobChatView. Handles WebSockets, APIs, and state.
class JobChatController {
  final String jobId;
  final AudioManager audioManager = AudioManager();
  final WebSocketClient _socketService = WebSocketClient();
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;

  List<dynamic> messages = [];
  bool isLoading = true;

  JobChatController({required this.jobId});

  /// Fetches chat history and connects the socket.
  Future<void> initChat(VoidCallback onStateUpdate, VoidCallback scrollToBottom) async {
    isLoading = true;
    onStateUpdate();

    final history = await ApiService.instance.getChatHistory(jobId);
    messages = history;
    isLoading = false;
    onStateUpdate();
    
    scrollToBottom();
    _connectSocket(onStateUpdate, scrollToBottom);
  }

  void _connectSocket(VoidCallback onStateUpdate, VoidCallback scrollToBottom) {
    final token = ApiService.instance.authToken;
    if (token == null) return;

    _socketSubscription?.cancel();
    _socketSubscription = _socketService
        .connect(jobId: jobId, token: token)
        .listen((msg) => _appendMessage(msg, onStateUpdate, scrollToBottom), onError: (_) {});
  }

  void _appendMessage(Map<String, dynamic> message, VoidCallback onStateUpdate, VoidCallback scrollToBottom) {
    final messageId = message['id'];
    final exists = messages.any((item) => item['id'] == messageId);
    if (exists) return;

    messages.add(message);
    onStateUpdate();
    scrollToBottom();
  }

  Future<bool> sendTextMessage(String content) async {
    if (content.isEmpty) return false;
    final sent = await ApiService.instance.sendTextMessage(jobId, content);
    return sent != null;
  }

  Future<void> toggleRecording(BuildContext context, VoidCallback onStateUpdate) async {
    if (audioManager.isRecording) {
      final path = await audioManager.stopRecording();
      onStateUpdate();

      if (path != null) {
        final sent = await ApiService.instance.sendVoiceNote(jobId, File(path));
        if (sent == null && context.mounted) {
          SnackbarUtils.showError(context, 'Failed to send voice note.');
        }
      }
    } else {
      final started = await audioManager.startRecording();
      if (!started && context.mounted) {
        SnackbarUtils.showError(context, 'Microphone permission is required.');
      }
      onStateUpdate();
    }
  }

  void playVoiceNote(String url) {
    audioManager.playVoiceNote(url);
  }

  bool isMine(Map<String, dynamic> message) {
    final sender = message['sender'];
    return sender != null && sender.toString() == currentUserId;
  }

  String get currentUserId {
    final token = ApiService.instance.authToken;
    if (token == null) return '';
    final decoded = JwtDecoder.decode(token);
    return decoded['user_id']?.toString() ?? decoded['id']?.toString() ?? '';
  }

  void dispose() {
    _socketSubscription?.cancel();
    _socketService.dispose();
    audioManager.dispose();
  }
}
