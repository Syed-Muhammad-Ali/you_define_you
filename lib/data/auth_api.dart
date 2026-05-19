import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

class AuthApi {
  final http.Client _client;

  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$kApiBaseUrl/auth/login');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      final body = _decode(response.body);
      final message = body['detail'] as String? ?? body['message'] as String?;
      throw ApiException(message ?? 'Unable to sign in right now. Please try again.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException('Unexpected response from the server.');
    }

    return AuthResponse.fromJson(decoded);
  }

  Future<String> forgotPassword({required String email}) async {
    final uri = Uri.parse('$kApiBaseUrl/auth/forgot-password');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final body = _decode(response.body);
    if (response.statusCode != 200) {
      throw ApiException(body['message'] ?? 'Unable to start password reset right now.');
    }

    return body['message'] as String? ?? 'If an account exists for that email, reset instructions and your app token have been sent.';
  }

  Future<String> resetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    final uri = Uri.parse('$kApiBaseUrl/auth/reset-password');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'token': token,
        'password': password,
      }),
    );

    final body = _decode(response.body);
    if (response.statusCode != 200) {
      throw ApiException(body['message'] ?? 'Unable to reset your password right now.');
    }

    return body['message'] as String? ?? 'Your password has been updated successfully.';
  }

  Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return {};
  }
}

class AuthResponse {
  final String token;
  final String email;
  final String firstName;
  final String lastName;
  final String planKey;
  final String planName;
  final String planPriceLabel;

  AuthResponse({
    required this.token,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.planKey = '',
    this.planName = '',
    this.planPriceLabel = '',
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['access_token'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      planKey: json['plan_key'] as String? ?? '',
      planName: json['plan_name'] as String? ?? '',
      planPriceLabel: json['plan_price_label'] as String? ?? '',
    );
  }
}
