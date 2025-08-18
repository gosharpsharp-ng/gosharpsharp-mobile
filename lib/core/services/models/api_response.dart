import 'dart:convert';

class APIResponse {
  String status;
  String message;
  dynamic data;
  APIResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': status,
      'message': message,
      'data': data,
    };
  }

  factory APIResponse.fromMap(Map<String, dynamic> map) {
    return APIResponse(
      status: map['status'] ??"" ,
      message: map['message']?? map['error']??"",
      data: map['data'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory APIResponse.fromJson(String source) =>
      APIResponse.fromMap(json.decode(source));
}
