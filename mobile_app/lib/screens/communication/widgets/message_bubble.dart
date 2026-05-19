import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A widget representing a single chat bubble.
class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMine;
  final ValueChanged<String> onPlayVoiceNote;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.onPlayVoiceNote,
  });

  @override
  Widget build(BuildContext context) {
    final sender = message['sender_details'] ?? {};
    final senderName = sender['full_name'] ?? sender['phone_number'] ?? 'User';
    final voiceUrl = message['voice_note_url'];

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 290),
        decoration: BoxDecoration(
          color: isMine ? AppColors.providerPrimary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isMine ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            if ((message['message_type'] ?? 'TEXT') == 'VOICE' && voiceUrl != null)
              InkWell(
                onTap: () => onPlayVoiceNote(voiceUrl.toString()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_fill, color: isMine ? Colors.white : AppColors.providerPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Play voice note',
                      style: TextStyle(color: isMine ? Colors.white : AppColors.providerPrimary),
                    ),
                  ],
                ),
              )
            else
              Text(
                message['content']?.toString() ?? '',
                style: TextStyle(color: isMine ? Colors.white : Colors.black87),
              ),
          ],
        ),
      ),
    );
  }
}
