import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

class DiaryApi {
  final http.Client _client;

  DiaryApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> loadEntries(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/diary/$token');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      final body = _decode(response.body);
      throw ApiException(body['message'] ?? 'Unable to load diary entries.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException('Unexpected diary response format.');
    }

    final entries = decoded['entries'] as List<dynamic>? ?? [];
    return entries
        .whereType<Map<String, dynamic>>()
        .map((entry) => {
              'id': entry['id'],
              'date': entry['entry_date'] ?? entry['date'],
              'score': entry['score'],
              'summary': entry['summary'],
              'thought': entry['thought'],
              'ts': entry['ts'],
              'created_at': entry['created_at'],
            })
        .toList();
  }

  Future<Map<String, dynamic>> saveEntry(String token, Map<String, dynamic> entry) async {
    final uri = Uri.parse('$kApiBaseUrl/diary');
    final payload = {
      'token': token,
      'entry': {
        'date': entry['date'],
        'entry_date': entry['entry_date'],
        'score': entry['score'],
        'summary': entry['summary'],
        'thought': entry['thought'],
        'ts': entry['ts'],
      },
    };

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      final body = _decode(response.body);
      throw ApiException(body['message'] ?? 'Unable to save diary entry.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException('Unexpected diary response format.');
    }

    return decoded['entry'] as Map<String, dynamic>? ?? {};
  }

  Map<String, dynamic> _decode(String body) {
    try {
      final value = jsonDecode(body);
      if (value is Map<String, dynamic>) {
        return value;
      }
    } catch (_) {}
    return {};
  }
}
