import 'dart:convert';

import '../../../domain/entities/common/error_response.dart';

class ErrorResponseModel extends ErrorResponse {
  ErrorResponseModel({
    this.responseCode,
    this.responseError,
    this.isSuceess,
  }) : super(
            responseCode: responseCode,
            responseError: responseError,
            isSuceess: isSuceess);

  String? responseCode;
  String? responseError;
  bool? isSuceess;

  factory ErrorResponseModel.fromRawJson(String str) =>
      ErrorResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      ErrorResponseModel(
        responseCode: json["response_code"],
        responseError: json["message"],
        isSuceess: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "message": responseError,
      };
}
