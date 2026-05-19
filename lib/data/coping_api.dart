import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_models.dart';
import 'api_config.dart';
import 'api_exception.dart';

class CopingApi {
  final http.Client _client;

  CopingApi({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<void> save(String token, CopingCheckinEntry entry) async {
    final uri = Uri.parse('$kApiBaseUrl/user/coping-checkins');
    final createdAt = DateTime.fromMillisecondsSinceEpoch(entry.createdAtEpochMs).toUtc().toIso8601String();
    final response = await _client.post(
      uri,
      headers: _headers(token),
      body: jsonEncode({
        'score': entry.score,
        'down': entry.down,
        'up': entry.up,
        'action': entry.action,
        'change': entry.change,
        'created_at': createdAt,
      }),
    );
    if (response.statusCode != 201) {
      final body = _decode(response.body);
      throw ApiException(body['detail'] as String? ?? 'Unable to save coping check-in.');
    }
  }

  Future<void> deleteAll(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/user/coping-checkins');
    await _client
        .delete(uri, headers: _headers(token))
        .catchError((_) => http.Response('', 204));
  }

  Future<List<CopingCheckinEntry>> load(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/user/coping-checkins');
    final response = await _client.get(uri, headers: _headers(token));
    if (response.statusCode != 200) {
      final body = _decode(response.body);
      throw ApiException(body['detail'] as String? ?? 'Unable to load coping check-ins.');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .whereType<Map<String, dynamic>>()
        .map((item) {
          final dt = DateTime.tryParse(item['created_at'] as String? ?? '') ?? DateTime.now();
          return CopingCheckinEntry(
            dateLabel: _dateLabel(dt.toLocal()),
            score: (item['score'] as num).toInt(),
            down: item['down'] as String? ?? '',
            up: item['up'] as String? ?? '',
            action: item['action'] as String? ?? '',
            change: item['change'] as String? ?? '',
            createdAtEpochMs: dt.millisecondsSinceEpoch,
          );
        })
        .toList();
  }

  String _dateLabel(DateTime date) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday % 7]} ${date.day} ${months[date.month - 1]}';
  }

  Map<String, dynamic> _decode(String body) {
    try {
      final v = jsonDecode(body);
      if (v is Map<String, dynamic>) return v;
    } catch (_) {}
    return {};
  }
}
