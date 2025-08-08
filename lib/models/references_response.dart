// models/references_response.dart
import 'package:appregdatainspect/models/reference_model.dart';

class ReferencesResponse {
  final int code;
  final String message;
  final List<Reference> data;

  ReferencesResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ReferencesResponse.fromJson(Map<String, dynamic> json) {
    return ReferencesResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => Reference.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
