import 'dart:convert';

GetQuestionDataResponse getQuestionDataResponseFromJson(String str) =>
    GetQuestionDataResponse.fromJson(json.decode(str));

String getQuestionDataResponseToJson(GetQuestionDataResponse data) =>
    json.encode(data.toJson());

class GetQuestionDataResponse {
  final QuestionData? data;
  final String? message;
  final bool success;

  GetQuestionDataResponse({
    this.data,
    this.message,
    required this.success,
  });

  factory GetQuestionDataResponse.fromJson(Map<String, dynamic> json) =>
      GetQuestionDataResponse(
        data: json["data"] == null ? null : QuestionData.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "message": message,
        "success": success,
      };
}

class QuestionData {
  final List<Question>? questions;
  final int? quizId;
  final String? quizTitle;

  QuestionData({
    this.questions,
    this.quizId,
    this.quizTitle,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) => QuestionData(
        questions: json["questions"] == null
            ? []
            : List<Question>.from(
                json["questions"]!.map((x) => Question.fromJson(x))),
        quizId: json["quiz_id"],
        quizTitle: json["quiz_title"],
      );

  Map<String, dynamic> toJson() => {
        "questions": questions == null
            ? []
            : List<dynamic>.from(questions!.map((x) => x.toJson())),
        "quiz_id": quizId,
        "quiz_title": quizTitle,
      };
}

class Question {
  final String? correctAnswer;
  final int? id;
  final Options? options;
  final String? questionText;

  Question({
    this.correctAnswer,
    this.id,
    this.options,
    this.questionText,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        correctAnswer: json["correct_answer"],
        id: json["id"],
        options:
            json["options"] == null ? null : Options.fromJson(json["options"]),
        questionText: json["question_text"],
      );

  Map<String, dynamic> toJson() => {
        "correct_answer": correctAnswer,
        "id": id,
        "options": options?.toJson(),
        "question_text": questionText,
      };
}

class Options {
  final String? a;
  final String? b;
  final String? c;
  final String? d;

  Options({
    this.a,
    this.b,
    this.c,
    this.d,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        a: json["a"],
        b: json["b"],
        c: json["c"],
        d: json["d"],
      );

  Map<String, dynamic> toJson() => {
        "a": a,
        "b": b,
        "c": c,
        "d": d,
      };
}
