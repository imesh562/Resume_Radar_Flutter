import 'dart:convert';

GetQuestionDataRequest getQuestionDataRequestFromJson(String str) =>
    GetQuestionDataRequest.fromJson(json.decode(str));

String getQuestionDataRequestToJson(GetQuestionDataRequest data) =>
    json.encode(data.toJson());

class GetQuestionDataRequest {
  final String? quizId;

  GetQuestionDataRequest({
    this.quizId,
  });

  factory GetQuestionDataRequest.fromJson(Map<String, dynamic> json) =>
      GetQuestionDataRequest(
        quizId: json["quiz_id"],
      );

  Map<String, dynamic> toJson() => {
        "quiz_id": quizId,
      };
}
