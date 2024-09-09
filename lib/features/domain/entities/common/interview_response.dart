class InterviewResponse {
  final String? question;
  final bool hasEnded;
  final Performance? performance;

  InterviewResponse({
    required this.question,
    required this.hasEnded,
    this.performance,
  });

  factory InterviewResponse.fromJson(Map<String, dynamic> json) {
    return InterviewResponse(
      question: json['question'],
      hasEnded: json['has_ended'],
      performance: json['performance'] != null
          ? Performance.fromJson(json['performance'])
          : null,
    );
  }
}

class Performance {
  final int overallScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;

  Performance({
    required this.overallScore,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      overallScore: json['overall_score'],
      strengths: List<String>.from(json['strengths']),
      weaknesses: List<String>.from(json['weaknesses']),
      recommendations: List<String>.from(json['recommendations']),
    );
  }
}
