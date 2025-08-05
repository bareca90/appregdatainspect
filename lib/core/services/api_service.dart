import 'dart:convert';
import 'package:appregdatainspect/models/auth_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client _client;
  static const String baseUrl =
      'http://10.100.123.11:8800/api-kilosremitidosapp-v1';
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponse> validateUser(String username, String password) async {
    final response = await _client.post(
      //10.20.4.173:8077 Servidor Desarrollo
      Uri.parse(
        'http://10.100.123.11:8800/api-kilosremitidosapp-v1/auth/validateuser',
      ),
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
      throw Exception('Failed to validate user');
    }
  }
}
