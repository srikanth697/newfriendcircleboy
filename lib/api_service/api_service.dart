import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoint.dart';

class ApiService {
  final String _baseUrl = ApiEndPoints.baseUrls;
  final Duration _timeout = const Duration(seconds: 20);

  Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse("$_baseUrl$endpoint");

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data),
          )
          .timeout(_timeout);

      dynamic parsedBody;
      try {
        parsedBody =
            response.body.isNotEmpty ? jsonDecode(response.body) : {};
      } catch (_) {
        parsedBody = {"raw": response.body};
      }

      final Map<String, dynamic> result = <String, dynamic>{
        "_status": response.statusCode,
      };

      if (parsedBody is Map<String, dynamic>) {
        result.addAll(parsedBody);
      } else {
        result["data"] = parsedBody;
      }

      return result;
    } catch (e) {
      throw Exception("POST request error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchBrowseFemales({
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl${ApiEndPoints.maleBrowseFemales}?page=$page&limit=$limit',
    );

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    final response = await http.get(uri, headers: headers).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load females: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      return (decoded['data'] as List).cast<Map<String, dynamic>>();
    }

    return const [];
  }
}