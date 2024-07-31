import 'dart:convert';

UserRegisterRequest userRegisterRequestFromJson(String str) =>
    UserRegisterRequest.fromJson(json.decode(str));

String userRegisterRequestToJson(UserRegisterRequest data) =>
    json.encode(data.toJson());

class UserRegisterRequest {
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;

  UserRegisterRequest({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
  });

  factory UserRegisterRequest.fromJson(Map<String, dynamic> json) =>
      UserRegisterRequest(
        email: json["email"],
        password: json["password"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
      };
}
