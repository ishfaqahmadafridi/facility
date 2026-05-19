import 'package:flutter/material.dart';

/// Reusable widget to display the status of the voice call.
class VoiceCallStatusText extends StatelessWidget {
  final String? error;
  final bool isJoining;
  final bool remoteJoined;
  final bool joined;

  const VoiceCallStatusText({
    super.key,
    required this.error,
    required this.isJoining,
    required this.remoteJoined,
    required this.joined,
  });

  @override
  Widget build(BuildContext context) {
    final text = error ??
        (isJoining
            ? 'Connecting to Agora voice channel...'
            : remoteJoined
                ? 'Call in progress'
                : joined
                    ? 'Waiting for the other person to join'
                    : 'Preparing call');

    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white70),
    );
  }
}
