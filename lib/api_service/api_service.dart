// lib/api_service/api_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_endpoint.dart';

class ApiService {
  final String _baseUrl = ApiEndPoints.baseUrls;
  final Duration _timeout = const Duration(seconds: 20);

  /// POST: returns a Map for both success and error responses.
  /// Returned map will always include a `_status` integer with HTTP status code.
  Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse("$_baseUrl$endpoint");

    try {
      debugPrint?.call("📤 POST to $url with body: ${jsonEncode(data)}");

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json", // same as curl
            },
            body: jsonEncode(data),
          )
          .timeout(_timeout);

      debugPrint?.call("📥 Response ${response.statusCode}: ${response.body}");

      // Try to parse JSON body (if not JSON, wrap raw body)
      dynamic parsedBody;
      try {
        parsedBody = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      } catch (_) {
        parsedBody = {"raw": response.body};
      }

      // Always return a Map that includes the status code
      final Map<String, dynamic> result = <String, dynamic>{
        "_status": response.statusCode,
      };

      if (parsedBody is Map<String, dynamic>) {
        result.addAll(parsedBody);
      } else {
        // if server returned a list or string, put under key "data" or "raw"
        result["data"] = parsedBody;
      }

      return result;
    } catch (e) {
      // network / timeout errors: surface as exception
      throw Exception("POST request error: $e");
    }
  }
}
