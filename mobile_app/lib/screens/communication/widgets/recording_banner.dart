import 'package:flutter/material.dart';

/// The red banner that appears when a voice note is being recorded.
class RecordingBanner extends StatelessWidget {
  final bool isRecording;
  final String? recordingPath;

  const RecordingBanner({
    super.key,
    required this.isRecording,
    required this.recordingPath,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRecording) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.red.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        'Recording voice note... ${recordingPath != null ? 'Tap mic again to send.' : ''}',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
