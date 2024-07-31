import 'dart:convert';

AuthUserResponse authUserResponseFromJson(String str) =>
    AuthUserResponse.fromJson(json.decode(str));

String authUserResponseToJson(AuthUserResponse data) =>
    json.encode(data.toJson());

class AuthUserResponse {
  final bool success;
  final String? message;
  final AuthUser? authUser;

  AuthUserResponse({
    required this.success,
    this.message,
    this.authUser,
  });

  factory AuthUserResponse.fromJson(Map<String, dynamic> json) =>
      AuthUserResponse(
        success: json["success"],
        message: json["message"],
        authUser: json["data"] == null ? null : AuthUser.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": authUser?.toJson(),
      };
}

class AuthUser {
  final String? email;
  final int? userId;

  AuthUser({
    this.email,
    this.userId,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        email: json["email"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "user_id": userId,
      };
}
