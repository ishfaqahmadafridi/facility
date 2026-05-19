import 'package:flutter/material.dart';

/// The bottom controls for the voice call (mute, end call).
class VoiceCallControls extends StatelessWidget {
  final bool muted;
  final bool joined;
  final VoidCallback onToggleMute;
  final VoidCallback onEndCall;

  const VoiceCallControls({
    super.key,
    required this.muted,
    required this.joined,
    required this.onToggleMute,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: muted ? Colors.orange : Colors.white24,
          child: IconButton(
            onPressed: joined ? onToggleMute : null,
            icon: Icon(muted ? Icons.mic_off : Icons.mic, color: Colors.white),
          ),
        ),
        const SizedBox(width: 24),
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.red,
          child: IconButton(
            onPressed: onEndCall,
            icon: const Icon(Icons.call_end, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
