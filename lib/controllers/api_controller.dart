// lib/controllers/api_controller.dart
import 'package:flutter/foundation.dart';
import '../api_service/api_service.dart';
import '../api_service/api_endpoint.dart';
import '../models/signup_request.dart';

class ApiController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _signupResponse;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get signupResponse => _signupResponse;

  /// Signup returns true if backend indicates success (success == true).
  /// On failure returns false and sets [_error] with a user-friendly message.
  Future<bool> signup({required String mobile, required String email}) async {
    _isLoading = true;
    _error = null;
    _signupResponse = null;
    notifyListeners();

    try {
      final payload = SignupRequest(
        email: email,
        mobileNumber: mobile,
      ).toJson();
      debugPrint("📤 Signup request: $payload");

      final res = await _apiService.postData(ApiEndPoints.signup, payload);

      debugPrint("📥 Signup raw returned map: $res");

      _signupResponse = res;
      _isLoading = false;

      // status from server
      final int status = (res["_status"] as int?) ?? 0;

      // If server returned a success boolean, treat it
      if (res.containsKey("success")) {
        final ok = res["success"] == true;
        if (ok) {
          notifyListeners();
          return true;
        } else {
          // Backend says success=false — try to surface message or error
          final message =
              (res["message"] ?? res["error"] ?? "Signup failed") as String;
          _error = _friendlyMessageFromServerMessage(message);
          notifyListeners();
          return false;
        }
      }

      // If status is 2xx but no 'success' flag, treat as success
      if (status >= 200 && status < 300) {
        notifyListeners();
        return true;
      }

      // Non-2xx without explicit success flag: extract friendly message if possible
      final message =
          (res["message"] ?? res["error"] ?? "Server error (code $status)")
              as String;
      _error = _friendlyMessageFromServerMessage(message);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      debugPrint("❌ Signup exception: $_error");
      notifyListeners();
      return false;
    }
  }

  /// Map server error messages to nicer UI strings when possible
  String _friendlyMessageFromServerMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.contains("duplicate key") ||
        lower.contains("dup key") ||
        lower.contains("duplicate")) {
      return "This email is already registered. Please log in or use a different email.";
    }
    if (lower.contains("invalid") && lower.contains("email")) {
      return "Please provide a valid email address.";
    }
    // fallback to original message
    return message;
  }
}
