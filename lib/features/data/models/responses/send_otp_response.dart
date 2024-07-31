import 'dart:convert';

SendOtpResponse sendOtpResponseFromJson(String str) =>
    SendOtpResponse.fromJson(json.decode(str));

String sendOtpResponseToJson(SendOtpResponse data) =>
    json.encode(data.toJson());

class SendOtpResponse {
  final bool success;
  final String? message;
  final dynamic data;

  SendOtpResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      SendOtpResponse(
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
