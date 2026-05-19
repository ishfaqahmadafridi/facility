import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The bottom text input and voice recording bar for the chat view.
class ChatInputField extends StatelessWidget {
  final TextEditingController textController;
  final bool isRecording;
  final VoidCallback onToggleRecording;
  final VoidCallback onSendMessage;

  const ChatInputField({
    super.key,
    required this.textController,
    required this.isRecording,
    required this.onToggleRecording,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              onPressed: onToggleRecording,
              icon: Icon(isRecording ? Icons.stop_circle : Icons.mic, color: Colors.red),
            ),
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                ),
                minLines: 1,
                maxLines: 4,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.providerPrimary,
              child: IconButton(
                onPressed: onSendMessage,
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
