part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent extends BaseEvent {}

class GetQuizzesEvent extends QuizEvent {
  final GetQuizzesRequest getQuizzesRequest;

  GetQuizzesEvent({
    required this.getQuizzesRequest,
  });
}

class GetQuestionDataEvent extends QuizEvent {
  final String questionsId;

  GetQuestionDataEvent({
    required this.questionsId,
  });
}
