import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ...existing code...
import '../api_service/api_endpoint.dart';

class ApiService {
  // Update user profile (PATCH)
  Future<Map<String, dynamic>> updateUserProfile({
    required Map<String, dynamic> fields,
    List<http.MultipartFile>? images,
  }) async {
    final url = Uri.parse('${ApiEndPoints.baseUrls}/male-user/profile-details');
    final request = http.MultipartRequest('PATCH', url);

    // Add headers
    final headers = await _getHeaders();
    // Remove Content-Type header as it will be set automatically by MultipartRequest
    headers.remove('Content-Type'); // This is set automatically for multipart
    request.headers.addAll(headers);

    // Add fields
    fields.forEach((key, value) {
      if (value != null) request.fields[key] = value.toString();
    });

    // Add images if any
    if (images != null) {
      request.files.addAll(images);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Check if response is JSON before parsing
    final contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('application/json')) {
      throw Exception('API returned non-JSON response: ${response.body}');
    }

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      _handleError(response.statusCode, response.body);
      throw Exception('Failed to update profile');
    }
  }

  // Fetch sent follow requests
  Future<List<Map<String, dynamic>>> fetchSentFollowRequests() async {
    final url = Uri.parse(
      '${ApiEndPoints.baseUrls}/male-user/follow-requests/sent',
    );
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    // Check if response is JSON before parsing
    final contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('application/json')) {
      _handleError(response.statusCode, response.body);
      throw Exception('API returned non-JSON response');
    }

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];
      if (data is List) {
        return data
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        return <Map<String, dynamic>>[];
      }
    } else {
      _handleError(response.statusCode, response.body);
      throw Exception('Failed to fetch sent follow requests');
    }
  }

  // Send follow request to a female user
  Future<Map<String, dynamic>> sendFollowRequest({
    required String femaleUserId,
  }) async {
    final url = Uri.parse(
      '${ApiEndPoints.baseUrls}/male-user/follow-request/send',
    );
    final headers = await _getHeaders();
    final body = jsonEncode({"femaleUserId": femaleUserId});

    final response = await http.post(url, headers: headers, body: body);

    // Check if response is JSON before parsing
    final contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('application/json')) {
      _handleError(response.statusCode, response.body);
      throw Exception('API returned non-JSON response');
    }

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      _handleError(response.statusCode, response.body);
      throw Exception('Failed to send follow request');
    }
  }

  final String baseUrl = ApiEndPoints.baseUrls;
  String? _authToken;

  // Get auth token from shared preferences
  Future<void> _getAuthToken() async {
    if (_authToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('token');
    }
  }

  // Get headers with authorization
  Future<Map<String, String>> _getHeaders() async {
    await _getAuthToken();

    // Check if token is valid (not null and not empty)
    if (_authToken == null || _authToken!.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('access_token');
      throw Exception('No valid token found. Please log in again.');
    }

    return {
      'Content-Type':
          'application/json', // Default to JSON, but will be overridden for multipart
      'Authorization': 'Bearer $_authToken',
    };
  }

  // Handle API errors
  void _handleError(int statusCode, dynamic responseBody) {
    String message = 'Failed to load data';
    try {
      // Check if response is JSON before parsing
      if (responseBody is String &&
          responseBody.startsWith('{') &&
          responseBody.endsWith('}')) {
        final jsonResponse = json.decode(responseBody);
        message = jsonResponse['message'] ?? jsonResponse['error'] ?? message;
      } else {
        message = 'Error: $statusCode';
      }
    } catch (e) {
      // If we can't parse the error message, use the status code
      message = 'Error: $statusCode';
    }
    throw Exception(message);
  }

  // Fetch female users with pagination
  Future<List<Map<String, dynamic>>> fetchFemaleUsers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/male-user/browse-females?page=$page&limit=$limit'),
        headers: await _getHeaders(),
      );

      // Check if response is JSON before parsing
      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        _handleError(response.statusCode, response.body);
        throw Exception('API returned non-JSON response');
      }

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // Expecting { data: [ ... ] }
        final data = decoded['data'];
        if (data is List) {
          return data
              .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
              .toList();
        } else {
          return <Map<String, dynamic>>[];
        }
      } else {
        _handleError(response.statusCode, response.body);
        throw Exception('Failed to load female users');
      }
    } on SocketException {
      throw Exception('Network error: Please check your internet connection');
    } on http.ClientException {
      throw Exception('Connection error: Unable to connect to server');
    } catch (e) {
      // Check if the error is related to token/auth
      if (e.toString().toLowerCase().contains('invalid token') ||
          e.toString().toLowerCase().contains('unauthorized') ||
          e.toString().contains('401')) {
        // Clear the invalid token
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('access_token');
        _authToken = null;
        throw Exception('Invalid token: Please log in again');
      }
      throw Exception('Network error: $e');
    }
  }

  // Register new male user
  Future<Map<String, dynamic>> registerMaleUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiEndPoints.baseUrls}${ApiEndPoints.signupMale}',
      );
      final body = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        if (referralCode != null && referralCode.isNotEmpty)
          'referralCode': referralCode,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Check if response is JSON before parsing
      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        _handleError(response.statusCode, response.body);
        throw Exception('API returned non-JSON response');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        return result;
      } else {
        _handleError(response.statusCode, response.body);
        throw Exception('Registration failed');
      }
    } catch (e) {
      // Check if the error is related to network or server
      if (e is SocketException || e is http.ClientException) {
        throw Exception('Network error: Please check your connection');
      }
      // Re-throw other exceptions (like server errors)
      rethrow;
    }
  }

  // Update user profile details
  Future<Map<String, dynamic>> updateProfileDetails({
    String? firstName,
    String? lastName,
    String? height,
    String? religion,
    String? imageUrl,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/male-user/profile-details');
      final body = <String, dynamic>{};

      if (firstName != null) body['firstName'] = firstName;
      if (lastName != null) body['lastName'] = lastName;
      if (height != null) body['height'] = height;
      if (religion != null) body['religion'] = religion;
      if (imageUrl != null) body['images'] = [imageUrl];

      final response = await http.patch(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      // Check if response is JSON before parsing
      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        _handleError(response.statusCode, response.body);
        throw Exception('API returned non-JSON response');
      }

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result;
      } else {
        _handleError(response.statusCode, response.body);
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      // Check if the error is related to network or server
      if (e is SocketException || e is http.ClientException) {
        throw Exception('Network error: Please check your connection');
      }
      // Re-throw other exceptions (like server errors)
      rethrow;
    }
  }

  // Fetch user profile
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/male-user/me'),
        headers: await _getHeaders(),
      );

      // Check if response is JSON before parsing
      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        _handleError(response.statusCode, response.body);
        throw Exception('API returned non-JSON response');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        _handleError(response.statusCode, response.body);
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  // Fetch current male user profile
  Future<Map<String, dynamic>> fetchCurrentMaleProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/male-user/me'),
        headers: await _getHeaders(),
      );

      // Check if response is JSON before parsing
      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        _handleError(response.statusCode, response.body);
        throw Exception('API returned non-JSON response');
      }

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result;
      } else {
        _handleError(response.statusCode, response.body);
        throw Exception('Failed to load current male profile');
      }
    } catch (e) {
      // Check if the error is related to network or server
      if (e is SocketException || e is http.ClientException) {
        throw Exception('Network error: Please check your connection');
      }
      // Re-throw other exceptions (like server errors)
      rethrow;
    }
  }
}
