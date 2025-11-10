import 'dart:convert';
import 'package:appregdatainspect/models/api_response.dart';
import 'package:appregdatainspect/models/auth_response.dart';
import 'package:appregdatainspect/models/reference_model.dart';
import 'package:appregdatainspect/models/references_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client _client;
  static const String baseUrl =
      'http://10.100.120.35:8440/api-registerdatainspectcontainer-v1';

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

  Future<ApiResponse> insertDataReference(
    Reference reference,
    String token,
    String username,
  ) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/data/insertdatareferences'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "reference": reference.reference,
        "releaseStartDate": reference.releaseStartDate?.toIso8601String().split(
          'T',
        )[0],
        "releaseStartTime": reference.releaseStartTime,
        "releaseFinishDate": reference.releaseFinishDate
            ?.toIso8601String()
            .split('T')[0],
        "releaseFinishTime": reference.releaseFinishTime,
        "sampleStartDate": reference.sampleStartDate?.toIso8601String().split(
          'T',
        )[0],
        "sampleStartTime": reference.sampleStartTime,
        "sampleFinishDate": reference.sampleFinishDate?.toIso8601String().split(
          'T',
        )[0],
        "sampleFinishTime": reference.sampleFinishTime,
        "stampedDate": reference.stampedDate?.toIso8601String().split('T')[0],
        "stampedTime": reference.stampedTime,
        "releaseTemperature": reference.releaseTemperature,
        "sampleTemperature": reference.sampleTemperature,
        "stampedTemperature": reference.stampedTemperature,
        "user": username,
      }),
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al sincronizar: ${response.statusCode}');
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
