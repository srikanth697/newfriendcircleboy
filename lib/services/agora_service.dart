// Centralized Agora service for audio/video calls
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  RtcEngine? _engine;
  bool _isInitialized = false;
  bool _videoEnabled = false;

  Future<void> initialize({
    required String appId,
    required bool enableVideo,
  }) async {
    if (_isInitialized) return;
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: appId));
    await _engine!.enableAudio();
    if (enableVideo) {
      await _engine!.enableVideo();
      // Set low video profile for minimal bandwidth/size
      await _engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 320, height: 180),
          frameRate: 15,
          bitrate: 140,
          orientationMode: OrientationMode.orientationModeFixedPortrait,
        ),
      );
      // Disable dual stream and fallback (API compatibility)
      await _engine!.enableDualStreamMode(enabled: false);
      await _engine!.setRemoteSubscribeFallbackOption(
        StreamFallbackOptions.streamFallbackOptionDisabled,
      );
      await _engine!.setLocalPublishFallbackOption(
        StreamFallbackOptions.streamFallbackOptionDisabled,
      );
      _videoEnabled = true;
    } else {
      await _engine!.disableVideo();
      _videoEnabled = false;
    }
    _isInitialized = true;
  }

  Future<void> joinChannel({
    required String token,
    required String channelId,
    required int uid,
    required bool enableVideo,
    required Function(int remoteUid) onUserJoined,
    required Function() onUserOffline,
    required Function() onJoinSuccess,
    required Function(String msg) onError,
  }) async {
    if (_engine == null) throw Exception('Agora engine not initialized');
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          onJoinSuccess();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          onUserJoined(remoteUid);
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              onUserOffline();
            },
        onError: (ErrorCodeType err, String msg) {
          onError(msg);
        },
      ),
    );
    if (enableVideo && !_videoEnabled) {
      await _engine!.enableVideo();
      _videoEnabled = true;
    } else if (!enableVideo && _videoEnabled) {
      await _engine!.disableVideo();
      _videoEnabled = false;
    }
    await _engine!.joinChannel(
      token: token,
      channelId: channelId,
      uid: uid,
      options: ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        publishMicrophoneTrack: true,
        publishCameraTrack: enableVideo,
      ),
    );
  }

  Future<void> leaveChannel() async {
    if (_engine != null) {
      try {
        await _engine!.leaveChannel();
        await _engine!.release();
      } catch (_) {}
      _engine = null;
      _isInitialized = false;
      _videoEnabled = false;
    }
  }

  RtcEngine? get engine => _engine;
}
