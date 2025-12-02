import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


/// Base URL for your token server. Override at build time with --dart-define.
const String kTokenServerBaseUrl = String.fromEnvironment(
  'TOKEN_BASE_URL',
  defaultValue: 'https://agora-token-server.onrender.com',
);


class TokenService {
  static const String _deviceIdKey = 'device_id';
  static String? _overrideDeviceId;


  static Future<String> getOrCreateDeviceId() async {
    if (_overrideDeviceId != null && _overrideDeviceId!.isNotEmpty) {
      return _overrideDeviceId!;
    }
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    await prefs.setString(_deviceIdKey, newId);
    return newId;
  }


  static Future<void> setDeviceId(String deviceId) async {
    _overrideDeviceId = deviceId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceIdKey, deviceId);
  }


  static Future<String> getCurrentDeviceId() async {
    return getOrCreateDeviceId();
  }

  static Future<String> fetchToken({required String channelName, required int uid}) async {
    try {
      final uri = Uri.parse('$kTokenServerBaseUrl/rtc/$channelName/publisher/uid/$uid');
      final response = await http.get(uri, headers: {'Accept': 'application/json'});
      if (response.statusCode != 200) {
        return '';
      }
      final body = json.decode(response.body);
      final token = body['rtcToken'] ?? body['token'] ?? body['rtctoken'];
      if (token is! String || token.isEmpty) {
        return '';
      }
      return token;
    } catch (e) {
      return '';
    }
  }


  static Future<void> sendInvite({
    required String toDeviceId,
    required String channelName,
    required bool isVideo,
    required String callerName,
  }) async {
    try {
      final fromDeviceId = await getOrCreateDeviceId();
      final uri = Uri.parse('$kTokenServerBaseUrl/invite');
      final payload = {
        'from': fromDeviceId,
        'to': toDeviceId,
        'channel': channelName,
        'isVideo': isVideo,
        'callerName': callerName,
      };
      await http.post(uri, body: json.encode(payload), headers: {
        'Content-Type': 'application/json',
      });
    } catch (e) {}
  }


  static Future<Map<String, dynamic>?> pollInvite() async {
    try {
      final deviceId = await getOrCreateDeviceId();
      final uri = Uri.parse('$kTokenServerBaseUrl/invite/$deviceId');
      final res = await http.get(uri, headers: {'Accept': 'application/json'});
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        if (data['channel'] != null) return data;
      }
    } catch (e) {}
    return null;
  }


  static Future<void> registerFcmToken(String token) async {
    try {
      final deviceId = await getOrCreateDeviceId();
      final uri = Uri.parse('$kTokenServerBaseUrl/register-token');
      await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'deviceId': deviceId,
            'fcmToken': token,
          }));
    } catch (e) {}
  }
}
