import 'package:flutter/material.dart';

import 'voice_call_controller.dart';
import 'widgets/voice_call_status_text.dart';
import 'widgets/voice_call_controls.dart';

class VoiceCallView extends StatefulWidget {
  final String jobId;
  final String title;

  const VoiceCallView({
    super.key,
    required this.jobId,
    required this.title,
  });

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  late final VoiceCallController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VoiceCallController(jobId: widget.jobId);
    _controller.joinCall(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleEndCall() async {
    await _controller.leaveCall();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFF1E293B),
                child: Icon(Icons.call, size: 42, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              VoiceCallStatusText(
                error: _controller.error,
                isJoining: _controller.isJoining,
                remoteJoined: _controller.remoteJoined,
                joined: _controller.joined,
              ),
              const SizedBox(height: 36),
              VoiceCallControls(
                muted: _controller.muted,
                joined: _controller.joined,
                onToggleMute: () => _controller.toggleMute(() {
                  if (mounted) setState(() {});
                }),
                onEndCall: _handleEndCall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
