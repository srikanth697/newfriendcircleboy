import 'dart:math';


import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';


class CallkitService {
  static Future<String> showIncomingCall({
    required String callerName,
    required String channelName,
    bool isVideo = true,
  }) async {
    final uuid = _randomUuid();
    final paramsMap = <String, dynamic>{
      'id': uuid,
      'nameCaller': callerName,
      'appName': 'AgoraVideoCall',
      'avatar': 'https://i.pravatar.cc/100?img=12',
      'handle': channelName,
      'type': isVideo ? 1 : 0,
      'duration': 30000,
      'textAccept': 'Accept',
      'textDecline': 'Decline',
      'extra': {
        'channelName': channelName,
      },
      'android': {
        'isCustomNotification': true,
        'ringtonePath': 'system_ringtone_default',
        'backgroundColor': '#0955fa',
        'isShowLogo': true,
      },
      'ios': {
        'iconName': 'CallKitLogo',
        'handleType': 'generic',
      }
    };
    await FlutterCallkitIncoming.showCallkitIncoming(CallKitParams.fromJson(paramsMap));
    return uuid;
  }


  static Future<void> endCall(String uuid) async {
    await FlutterCallkitIncoming.endCall(uuid);
  }


  static Future<void> showOutgoingCall({
    required String callId,
    required String targetName,
    required String channelName,
    bool isVideo = true,
  }) async {
    final paramsMap = <String, dynamic>{
      'id': callId,
      'nameCaller': targetName,
      'appName': 'AgoraVideoCall',
      'avatar': 'https://i.pravatar.cc/100?img=12',
      'handle': channelName,
      'type': isVideo ? 1 : 0,
      'extra': {
        'channelName': channelName,
        'isOutgoing': true,
      },
      'android': {
        'isCustomNotification': true,
        'backgroundColor': '#0955fa',
        'isShowLogo': true,
      },
      'ios': {
        'iconName': 'CallKitLogo',
        'handleType': 'generic',
      }
    };
    await FlutterCallkitIncoming.startCall(CallKitParams.fromJson(paramsMap));
  }


  static String _randomUuid() {
    final rand = Random();
    return List.generate(32, (_) => rand.nextInt(16).toRadixString(16)).join();
  }
}
