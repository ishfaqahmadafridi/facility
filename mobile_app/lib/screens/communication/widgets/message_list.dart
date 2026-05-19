import 'package:flutter/material.dart';
import 'message_bubble.dart';

/// A widget that displays the list of chat messages.
class MessageList extends StatelessWidget {
  final ScrollController scrollController;
  final List<dynamic> messages;
  final bool Function(Map<String, dynamic>) isMine;
  final ValueChanged<String> onPlayVoiceNote;

  const MessageList({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.isMine,
    required this.onPlayVoiceNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = (messages[index] as Map).cast<String, dynamic>();
        return MessageBubble(
          message: msg,
          isMine: isMine(msg),
          onPlayVoiceNote: onPlayVoiceNote,
        );
      },
    );
  }
}
