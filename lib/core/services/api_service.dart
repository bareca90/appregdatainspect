import 'dart:convert';
import 'package:appregdatainspect/models/auth_response.dart';
import 'package:appregdatainspect/models/references_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client _client;
  static const String baseUrl =
      'http://10.100.123.11:8440/api-registerdatainspectcontainer-v1';

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponse> validateUser(String username, String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/validateuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to validate user. Status code: ${response.statusCode}',
      );
    }
  }

  Future<ReferencesResponse> getReferences(String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/data/getreferences'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ReferencesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load references. Status code: ${response.statusCode}',
      );
    }
  }
}
