part of 'quiz_bloc.dart';

@immutable
abstract class QuizState extends BaseState<QuizState> {}

class QuizInitial extends QuizState {}

class GetQuizzesSuccessState extends QuizState {
  final QuizzesData quizzesData;
  final bool isRefresh;

  GetQuizzesSuccessState({
    required this.quizzesData,
    required this.isRefresh,
  });
}

class GetQuestionsDataSuccessState extends QuizState {
  final QuestionData questionData;

  GetQuestionsDataSuccessState({required this.questionData});
}
