import 'dart:convert';

LogOutResponse logOutResponseFromJson(String str) =>
    LogOutResponse.fromJson(json.decode(str));

String logOutResponseToJson(LogOutResponse data) => json.encode(data.toJson());

class LogOutResponse {
  final bool success;
  final String? message;
  final dynamic data;

  LogOutResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory LogOutResponse.fromJson(Map<String, dynamic> json) => LogOutResponse(
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
