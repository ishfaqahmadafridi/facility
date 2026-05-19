import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:facility/services/api_service.dart';

/// Controller for the Voice Call feature. Handles all Agora RTC engine logic.
class VoiceCallController {
  final String jobId;
  
  RtcEngine? _engine;
  bool isJoining = true;
  bool joined = false;
  bool remoteJoined = false;
  bool muted = false;
  String? error;

  VoiceCallController({required this.jobId});

  Future<void> joinCall(VoidCallback onStateUpdate) async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      isJoining = false;
      error = 'Microphone permission is required for calls.';
      onStateUpdate();
      return;
    }

    final config = await ApiService.instance.getAgoraCallConfig(jobId);

    if (config == null || config['app_id'] == null || config['token'] == null) {
      isJoining = false;
      error = 'Unable to start call. Check Agora backend configuration.';
      onStateUpdate();
      return;
    }

    final engine = createAgoraRtcEngine();
    await engine.initialize(
      RtcEngineContext(
        appId: config['app_id'].toString(),
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (_, __) {
          joined = true;
          isJoining = false;
          onStateUpdate();
        },
        onUserJoined: (_, __, ___) {
          remoteJoined = true;
          onStateUpdate();
        },
        onUserOffline: (_, __, ___) {
          remoteJoined = false;
          onStateUpdate();
        },
        onError: (code, message) {
          error = 'Agora error $code: $message';
          isJoining = false;
          onStateUpdate();
        },
      ),
    );

    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.joinChannel(
      token: config['token'].toString(),
      channelId: config['channel_name'].toString(),
      uid: int.tryParse(config['uid'].toString()) ?? 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
      ),
    );

    _engine = engine;
  }

  Future<void> leaveCall() async {
    final engine = _engine;
    if (engine != null) {
      await engine.leaveChannel();
      await engine.release();
      _engine = null;
    }
  }

  Future<void> toggleMute(VoidCallback onStateUpdate) async {
    final engine = _engine;
    if (engine == null) return;
    await engine.muteLocalAudioStream(muted);
    muted = !muted;
    onStateUpdate();
  }

  void dispose() {
    leaveCall();
  }
}
