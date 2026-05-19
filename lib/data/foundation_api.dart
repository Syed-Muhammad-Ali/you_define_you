import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_models.dart';
import 'api_config.dart';
import 'api_exception.dart';

class FoundationData {
  final Map<String, int> lifeScores;
  final Map<String, String> lifeNotes;
  final List<int> selectedBeliefs;
  final List<TimelineEventModel> timeline;
  final List<String> selectedTriggers;
  final List<bool> completedSteps;

  const FoundationData({
    required this.lifeScores,
    required this.lifeNotes,
    required this.selectedBeliefs,
    required this.timeline,
    required this.selectedTriggers,
    required this.completedSteps,
  });

  factory FoundationData.fromJson(Map<String, dynamic> json) {
    return FoundationData(
      lifeScores: (json['life_scores'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), (v as num).toInt()),
          ) ??
          {},
      lifeNotes: (json['life_notes'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          ) ??
          {},
      selectedBeliefs: (json['selected_beliefs'] as List?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      timeline: (json['timeline'] as List?)
              ?.map((e) => TimelineEventModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      selectedTriggers: (json['selected_triggers'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      completedSteps: (json['completed_steps'] as List?)
              ?.map((e) => e as bool)
              .toList() ??
          [false, false, false, false],
    );
  }

  Map<String, dynamic> toJson() => {
        'life_scores': lifeScores,
        'life_notes': lifeNotes,
        'selected_beliefs': selectedBeliefs,
        'timeline': timeline.map((e) => e.toJson()).toList(),
        'selected_triggers': selectedTriggers,
        'completed_steps': completedSteps,
      };
}

class FoundationApi {
  final http.Client _client;

  FoundationApi({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<FoundationData?> load(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/user/foundation');
    final response = await _client.get(uri, headers: _headers(token));
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      final body = _decode(response.body);
      throw ApiException(body['detail'] as String? ?? 'Unable to load foundation data.');
    }
    return FoundationData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> save(String token, FoundationData data) async {
    final uri = Uri.parse('$kApiBaseUrl/user/foundation');
    final response = await _client.put(
      uri,
      headers: _headers(token),
      body: jsonEncode(data.toJson()),
    );
    if (response.statusCode != 204) {
      final body = _decode(response.body);
      throw ApiException(body['detail'] as String? ?? 'Unable to save foundation data.');
    }
  }

  Future<void> delete(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/user/foundation');
    await _client
        .delete(uri, headers: _headers(token))
        .catchError((_) => http.Response('', 204));
  }

  Map<String, dynamic> _decode(String body) {
    try {
      final v = jsonDecode(body);
      if (v is Map<String, dynamic>) return v;
    } catch (_) {}
    return {};
  }
}
