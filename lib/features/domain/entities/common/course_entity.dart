class Course {
  int courseId;
  String courseTitle;
  String url;
  bool isPaid;
  double price;
  int numSubscribers;
  int numReviews;
  int numLectures;
  String level;
  double contentDuration;
  DateTime publishedTimestamp;
  String subject;

  Course({
    required this.courseId,
    required this.courseTitle,
    required this.url,
    required this.isPaid,
    required this.price,
    required this.numSubscribers,
    required this.numReviews,
    required this.numLectures,
    required this.level,
    required this.contentDuration,
    required this.publishedTimestamp,
    required this.subject,
  });

  factory Course.fromList(List<dynamic> row) {
    return Course(
      courseId: int.parse(row[0].toString()),
      courseTitle: row[1].toString(),
      url: row[2].toString(),
      isPaid: row[3].toString().toLowerCase() == 'true',
      price: double.parse(row[4].toString()),
      numSubscribers: int.parse(row[5].toString()),
      numReviews: int.parse(row[6].toString()),
      numLectures: int.parse(row[7].toString()),
      level: row[8].toString(),
      contentDuration: double.parse(row[9].toString()),
      publishedTimestamp: DateTime.parse(row[10].toString()),
      subject: row[11].toString(),
    );
  }
}
