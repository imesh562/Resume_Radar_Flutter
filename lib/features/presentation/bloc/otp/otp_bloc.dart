import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:resume_radar/features/data/datasources/shared_preference.dart';
import 'package:resume_radar/features/data/models/requests/send_otp_request.dart';
import 'package:resume_radar/features/data/models/requests/verify_otp_request.dart';
import 'package:resume_radar/features/domain/repositories/repository.dart';

import '../../../../error/failures.dart';
import '../../../../error/messages.dart';
import '../../../data/models/common/common_error_response.dart';
import '../../../data/models/requests/check_email_request.dart';
import '../base_bloc.dart';
import '../base_event.dart';
import '../base_state.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Base<OtpEvent, BaseState<OtpState>> {
  final AppSharedData appSharedData;
  final Repository repository;
  OtpBloc({
    required this.appSharedData,
    required this.repository,
  }) : super(OtpInitial()) {
    on<SendOtpEvent>(_sendOtp);
    on<VerifyOtpEvent>(_verifyOtp);
    on<CheckEmailEvent>(_checkEmail);
  }

  Future<void> _sendOtp(
      SendOtpEvent event, Emitter<BaseState<OtpState>> emit) async {
    emit(APILoadingState());
    final result = await repository.sendOtpRequest(
      SendOtpRequest(
        email: event.email,
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
        return SendOtpSuccessState(
          message: r.message ?? '',
          isSent: r.success,
        );
      } else {
        return APIFailureState(
            errorResponseModel:
                ErrorResponseModel(responseError: r.message, responseCode: ''));
      }
    }));
  }

  Future<void> _verifyOtp(
      VerifyOtpEvent event, Emitter<BaseState<OtpState>> emit) async {
    emit(APILoadingState());
    final result = await repository.verifyOtpRequest(VerifyOtpRequest(
      email: event.email,
      otp: event.otp,
    ));
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
        return VerifyOtpSuccessState();
      } else {
        return VerifyOtpFailedState(message: r.message ?? '');
      }
    }));
  }

  Future<void> _checkEmail(
      CheckEmailEvent event, Emitter<BaseState<OtpState>> emit) async {
    emit(APILoadingState());
    final result = await repository.checkEmailAPI(CheckEmailRequest(
      email: event.email,
    ));
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
        return CheckEmailSuccessState();
      } else {
        return APIFailureState(
            errorResponseModel:
                ErrorResponseModel(responseError: r.message, responseCode: ''));
      }
    }));
  }
}
