import 'dart:convert';

CheckEmailRequest checkEmailRequestFromJson(String str) =>
    CheckEmailRequest.fromJson(json.decode(str));

String checkEmailRequestToJson(CheckEmailRequest data) =>
    json.encode(data.toJson());

class CheckEmailRequest {
  final String? email;

  CheckEmailRequest({
    this.email,
  });

  factory CheckEmailRequest.fromJson(Map<String, dynamic> json) =>
      CheckEmailRequest(
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
