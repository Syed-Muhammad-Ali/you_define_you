import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_models.dart';
import 'api_config.dart';
import 'api_exception.dart';

class ToolsData {
  final int currentTool;
  final Set<int> completedTools;
  final List<WorkEntry> enquiryEntries;
  final List<WorkEntry> unwireEntries;

  const ToolsData({
    required this.currentTool,
    required this.completedTools,
    required this.enquiryEntries,
    required this.unwireEntries,
  });

  factory ToolsData.fromJson(Map<String, dynamic> json) => ToolsData(
        currentTool: (json['current_tool'] as num?)?.toInt() ?? 1,
        completedTools: ((json['completed_tools'] as List?) ?? [])
            .map((e) => (e as num).toInt())
            .toSet(),
        enquiryEntries: ((json['enquiry_entries'] as List?) ?? [])
            .map((e) => WorkEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        unwireEntries: ((json['unwire_entries'] as List?) ?? [])
            .map((e) => WorkEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'current_tool': currentTool,
        'completed_tools': completedTools.toList(),
        'enquiry_entries': enquiryEntries.map((e) => e.toJson()).toList(),
        'unwire_entries': unwireEntries.map((e) => e.toJson()).toList(),
      };
}

class ToolsApi {
  final http.Client _client;

  ToolsApi({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<ToolsData?> load(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/user/tools');
    final response = await _client.get(uri, headers: _headers(token));
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      final body = _decode(response.body);
      throw ApiException(body['detail'] as String? ?? 'Unable to load tool progress.');
    }
    return ToolsData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> save(String token, ToolsData data) async {
    final uri = Uri.parse('$kApiBaseUrl/user/tools');
    final response = await _client.put(
      uri,
      headers: _headers(token),
      body: jsonEncode(data.toJson()),
    );
    if (response.statusCode != 204) {
      final body = _decode(response.body);
      throw ApiException(body['detail'] as String? ?? 'Unable to save tool progress.');
    }
  }

  Future<void> delete(String token) async {
    final uri = Uri.parse('$kApiBaseUrl/user/tools');
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
