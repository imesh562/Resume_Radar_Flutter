import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final bool success;
  final String? message;
  final Data? data;

  LoginResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final String? token;
  final String? email;
  final int? userId;
  final String? firstName;
  final String? lastName;

  Data({
    this.token,
    this.email,
    this.userId,
    this.firstName,
    this.lastName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        email: json["email"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "email": email,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
      };
}
