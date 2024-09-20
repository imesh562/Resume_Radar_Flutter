import 'dart:async';

import 'package:bloc/src/bloc.dart';
import 'package:meta/meta.dart';
import 'package:resume_radar/features/data/models/requests/get_quizzes_request.dart';

import '../../../../error/failures.dart';
import '../../../../error/messages.dart';
import '../../../data/datasources/shared_preference.dart';
import '../../../data/models/common/common_error_response.dart';
import '../../../data/models/requests/get_questions_data_request.dart';
import '../../../data/models/responses/get_questions_data_responses.dart';
import '../../../data/models/responses/get_quizzes_response.dart';
import '../../../domain/repositories/repository.dart';
import '../base_bloc.dart';
import '../base_event.dart';
import '../base_state.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class OtpBloc extends Base<QuizEvent, BaseState<QuizState>> {
  final AppSharedData appSharedData;
  final Repository repository;
  OtpBloc({
    required this.appSharedData,
    required this.repository,
  }) : super(QuizInitial()) {
    on<GetQuizzesEvent>(_getQuizzes);
    on<GetQuestionDataEvent>(_getQuestionData);
  }

  Future<void> _getQuizzes(
      GetQuizzesEvent event, Emitter<BaseState<QuizState>> emit) async {
    emit(APILoadingState());
    final result = await repository.getQuizzesAPI(
      event.getQuizzesRequest,
    );
    emit(result.fold((l) {
      if (l is ServerFailure) {
        return APIFailureState(errorResponseModel: l.errorResponse);
      } else if (l is AuthorizedFailure) {
        return AuthorizedFailureState(errorResponseModel: l.errorResponse);
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }, (r) {
      if (r.success) {
        return GetQuizzesSuccessState(
          quizzesData: r.data!,
        );
      } else {
        return APIFailureState(
            errorResponseModel:
                ErrorResponseModel(responseError: r.message, responseCode: ''));
      }
    }));
  }

  Future<void> _getQuestionData(
      GetQuestionDataEvent event, Emitter<BaseState<QuizState>> emit) async {
    emit(APILoadingState());
    final result = await repository.getQuestionsDataAPI(
      GetQuestionDataRequest(
        quizId: event.questionsId,
      ),
    );
    emit(result.fold((l) {
      if (l is ServerFailure) {
        return APIFailureState(errorResponseModel: l.errorResponse);
      } else if (l is AuthorizedFailure) {
        return AuthorizedFailureState(errorResponseModel: l.errorResponse);
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }, (r) {
      if (r.success) {
        return GetQuestionsDataSuccessState(
          questionData: r.data!,
        );
      } else {
        return APIFailureState(
            errorResponseModel:
                ErrorResponseModel(responseError: r.message, responseCode: ''));
      }
    }));
  }
}
