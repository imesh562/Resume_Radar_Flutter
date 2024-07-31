import 'dart:convert';

CheckEmailResponse checkEmailResponseFromJson(String str) =>
    CheckEmailResponse.fromJson(json.decode(str));

String checkEmailResponseToJson(CheckEmailResponse data) =>
    json.encode(data.toJson());

class CheckEmailResponse {
  final bool success;
  final String? message;
  final dynamic data;

  CheckEmailResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory CheckEmailResponse.fromJson(Map<String, dynamic> json) =>
      CheckEmailResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
      };
}
