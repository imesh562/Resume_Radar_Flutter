import 'dart:convert';

GetQuizzesResponse getQuizzesResponseFromJson(String str) =>
    GetQuizzesResponse.fromJson(json.decode(str));

String getQuizzesResponseToJson(GetQuizzesResponse data) =>
    json.encode(data.toJson());

class GetQuizzesResponse {
  final QuizzesData? data;
  final String? message;
  final bool success;

  GetQuizzesResponse({
    this.data,
    this.message,
    required this.success,
  });

  factory GetQuizzesResponse.fromJson(Map<String, dynamic> json) =>
      GetQuizzesResponse(
        data: json["data"] == null ? null : QuizzesData.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "message": message,
        "success": success,
      };
}

class QuizzesData {
  final int? page;
  final List<Quiz>? quizzes;
  final int? totalCount;
  final int? totalPage;

  QuizzesData({
    this.page,
    this.quizzes,
    this.totalCount,
    this.totalPage,
  });

  factory QuizzesData.fromJson(Map<String, dynamic> json) => QuizzesData(
        page: json["page"],
        quizzes: json["quizzes"] == null
            ? []
            : List<Quiz>.from(json["quizzes"]!.map((x) => Quiz.fromJson(x))),
        totalCount: json["totalCount"],
        totalPage: json["totalPage"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "quizzes": quizzes == null
            ? []
            : List<dynamic>.from(quizzes!.map((x) => x.toJson())),
        "totalCount": totalCount,
        "totalPage": totalPage,
      };
}

class Quiz {
  final String? createdAt;
  final String? description;
  final int? id;
  final String? skill;
  final String? title;

  Quiz({
    this.createdAt,
    this.description,
    this.id,
    this.skill,
    this.title,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        createdAt: json["created_at"],
        description: json["description"],
        id: json["id"],
        skill: json["skill"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "description": description,
        "id": id,
        "skill": skill,
        "title": title,
      };
}
