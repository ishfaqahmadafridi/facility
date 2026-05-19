import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Utility class to manage audio recording and playback for the chat.
class AudioManager {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isRecording = false;
  String? recordingPath;

  /// Starts recording a voice note if permissions are granted.
  Future<bool> startRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      return false;
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
    
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );

    isRecording = true;
    recordingPath = path;
    return true;
  }

  /// Stops recording and returns the file path.
  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    isRecording = false;
    return path;
  }

  /// Plays a voice note from a URL.
  Future<void> playVoiceNote(String url) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(url));
  }

  /// Cleans up resources.
  void dispose() {
    _recorder.dispose();
    _audioPlayer.dispose();
  }
}
