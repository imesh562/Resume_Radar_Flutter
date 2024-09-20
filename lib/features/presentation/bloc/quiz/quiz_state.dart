part of 'quiz_bloc.dart';

@immutable
abstract class QuizState extends BaseState<QuizState> {}

class QuizInitial extends QuizState {}

class GetQuizzesSuccessState extends QuizState {
  final QuizzesData quizzesData;

  GetQuizzesSuccessState({required this.quizzesData});
}

class GetQuestionsDataSuccessState extends QuizState {
  final QuestionData questionData;

  GetQuestionsDataSuccessState({required this.questionData});
}
