import 'dart:convert';

UserRegisterResponse userRegisterResponseFromJson(String str) =>
    UserRegisterResponse.fromJson(json.decode(str));

String userRegisterResponseToJson(UserRegisterResponse data) =>
    json.encode(data.toJson());

class UserRegisterResponse {
  final bool success;
  final String? message;
  final dynamic data;

  UserRegisterResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory UserRegisterResponse.fromJson(Map<String, dynamic> json) =>
      UserRegisterResponse(
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
