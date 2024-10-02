part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent extends BaseEvent {}

class GetQuizzesEvent extends QuizEvent {
  final GetQuizzesRequest getQuizzesRequest;
  final bool isRefresh;

  GetQuizzesEvent({
    required this.getQuizzesRequest,
    required this.isRefresh,
  });
}

class GetQuestionDataEvent extends QuizEvent {
  final String questionsId;

  GetQuestionDataEvent({
    required this.questionsId,
  });
}
