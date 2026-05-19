import 'package:flutter/material.dart';

import 'job_chat_controller.dart';
import 'widgets/job_chat_app_bar.dart';
import 'widgets/job_chat_body.dart';

/// The main entry point for the job chat screen.
/// Completely decoupled and modularized for supreme readability.
class JobChatView extends StatefulWidget {
  final String jobId;
  final String title;

  const JobChatView({
    super.key,
    required this.jobId,
    required this.title,
  });

  @override
  State<JobChatView> createState() => _JobChatViewState();
}

class _JobChatViewState extends State<JobChatView> {
  late final JobChatController _controller;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = JobChatController(jobId: widget.jobId);
    _controller.initChat(() {
      if (mounted) setState(() {});
    }, _scrollToBottom);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage() async {
    final success = await _controller.sendTextMessage(_textController.text.trim());
    if (success) {
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobChatAppBar(title: widget.title),
      body: JobChatBody(
        controller: _controller,
        scrollController: _scrollController,
        textController: _textController,
        onToggleRecording: () => _controller.toggleRecording(context, () {
          if (mounted) setState(() {});
        }),
        onSendMessage: _handleSendMessage,
      ),
    );
  }
}
