import 'dart:convert';

VerifyOtpResponse verifyOtpResponseFromJson(String str) =>
    VerifyOtpResponse.fromJson(json.decode(str));

String verifyOtpResponseToJson(VerifyOtpResponse data) =>
    json.encode(data.toJson());

class VerifyOtpResponse {
  final bool success;
  final String? message;
  final dynamic data;

  VerifyOtpResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResponse(
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
