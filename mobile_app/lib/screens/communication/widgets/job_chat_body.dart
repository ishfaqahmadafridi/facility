import 'package:flutter/material.dart';

import '../job_chat_controller.dart';
import 'message_list.dart';
import 'dummy_components_grid.dart';
import 'recording_banner.dart';
import 'chat_input_field.dart';

/// Orchestrates the main content area of the job chat view.
class JobChatBody extends StatelessWidget {
  final JobChatController controller;
  final ScrollController scrollController;
  final TextEditingController textController;
  final VoidCallback onToggleRecording;
  final VoidCallback onSendMessage;

  const JobChatBody({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.textController,
    required this.onToggleRecording,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: MessageList(
                  scrollController: scrollController,
                  messages: controller.messages,
                  isMine: controller.isMine,
                  onPlayVoiceNote: controller.playVoiceNote,
                ),
              ),
              const SizedBox(height: 12),
              const DummyComponentsGrid(),
            ],
          ),
        ),
        RecordingBanner(
          isRecording: controller.audioManager.isRecording,
          recordingPath: controller.audioManager.recordingPath,
        ),
        ChatInputField(
          textController: textController,
          isRecording: controller.audioManager.isRecording,
          onToggleRecording: onToggleRecording,
          onSendMessage: onSendMessage,
        ),
      ],
    );
  }
}
