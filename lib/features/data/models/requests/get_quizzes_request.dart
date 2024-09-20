import 'dart:convert';

GetQuizzesRequest getQuizzesRequestFromJson(String str) =>
    GetQuizzesRequest.fromJson(json.decode(str));

String getQuizzesRequestToJson(GetQuizzesRequest data) =>
    json.encode(data.toJson());

class GetQuizzesRequest {
  final int? page;
  final int? perPage;
  final String? sort;

  GetQuizzesRequest({
    this.page,
    this.perPage,
    this.sort,
  });

  factory GetQuizzesRequest.fromJson(Map<String, dynamic> json) =>
      GetQuizzesRequest(
        page: json["page"],
        perPage: json["perPage"],
        sort: json["sort"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "perPage": perPage,
        "sort": sort,
      };
}
