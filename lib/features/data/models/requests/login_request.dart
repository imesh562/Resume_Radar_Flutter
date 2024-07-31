import 'dart:convert';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  final String? email;
  final String? password;
  final String? pushId;

  LoginRequest({
    this.email,
    this.password,
    this.pushId,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json["email"],
        password: json["password"],
        pushId: json["pushId"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "pushId": pushId,
      };
}
