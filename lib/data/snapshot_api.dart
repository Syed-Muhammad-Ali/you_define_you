import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

class SnapshotApi {
  final http.Client _client;

  SnapshotApi({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>?> load(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/user/snapshot');
    final response = await _client.get(uri, headers: _headers(token));
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      final body = _decode(response.body);
      throw ApiException(body['detail'] as String? ?? 'Unable to load your progress.');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['snapshot'] as Map<String, dynamic>?;
  }

  Future<void> save(String token, Map<String, dynamic> snapshot) async {
    final uri = Uri.parse('$kApiBaseUrl/user/snapshot');
    final response = await _client.put(
      uri,
      headers: _headers(token),
      body: jsonEncode({'snapshot': snapshot}),
    );
    if (response.statusCode != 204) {
      final body = _decode(response.body);
      throw ApiException(body['detail'] as String? ?? 'Unable to save your progress.');
    }
  }

  Future<void> delete(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/user/snapshot');
    await _client.delete(uri, headers: _headers(token)).catchError((_) => http.Response('', 204));
  }

  Map<String, dynamic> _decode(String body) {
    try {
      final v = jsonDecode(body);
      if (v is Map<String, dynamic>) return v;
    } catch (_) {}
    return {};
  }
}
