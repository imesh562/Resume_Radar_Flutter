import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../error/failures.dart';
import '../../../../error/messages.dart';
import '../../../../utils/app_constants.dart';
import '../../../data/datasources/shared_preference.dart';
import '../../../data/models/common/common_error_response.dart';
import '../../../data/models/requests/login_request.dart';
import '../../../data/models/requests/user_register_request.dart';
import '../../../data/models/responses/auth_user_response.dart';
import '../../../domain/repositories/repository.dart';
import '../base_bloc.dart';
import '../base_event.dart';
import '../base_state.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Base<UserEvent, BaseState<UserState>> {
  final AppSharedData appSharedData;
  final Repository repository;
  UserBloc({
    required this.appSharedData,
    required this.repository,
  }) : super(UserInitial()) {
    on<UserLoginEvent>(_userLogin);
    on<AuthUserEvent>(_authUser);
    on<LogOutEvent>(_logOut);
    on<UserRegisterEvent>(_userRegister);
  }

  Future<void> _userLogin(
      UserLoginEvent event, Emitter<BaseState<UserState>> emit) async {
    if (event.shouldShowProgress) {
      emit(APILoadingState());
    }
    final result = await repository.loginRequest(LoginRequest(
      email: event.userName,
      password: event.password,
      pushId: appSharedData.getPushToken(),
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
        appSharedData.setAppToken(r.data!.token!);
        AppConstants.IS_USER_LOGGED = true;
        if (event.rememberMe) {
          appSharedData.setRememberMe(true);
          appSharedData.setEmail(event.userName);
          appSharedData.setPassword(event.password);
        } else {
          appSharedData.setRememberMe(false);
          appSharedData.setEmail(event.userName);
          appSharedData.setPassword(event.password);
        }
        return LoginSuccessState();
      } else {
        return APIFailureState(
            errorResponseModel:
                ErrorResponseModel(responseError: r.message, responseCode: ''));
      }
    }));
  }

  Future<void> _authUser(
      AuthUserEvent event, Emitter<BaseState<UserState>> emit) async {
    if (event.shouldShowProgress) {
      emit(APILoadingState());
    }
    final result = await repository.authUserRequest();
    emit(result.fold((l) {
      if (l is ServerFailure) {
        return APIFailureState(errorResponseModel: l.errorResponse);
      } else if (l is AuthorizedFailure) {
        return AuthorizedFailureState(
          errorResponseModel: l.errorResponse,
          isSplash: event.isSplashView ?? false,
        );
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }, (r) {
      if (r.success) {
        appSharedData.setAppUser(r.authUser!);
        return AuthUserSuccessState(authUser: r.authUser!);
      } else {
        return APIFailureState(
            errorResponseModel:
                ErrorResponseModel(responseError: r.message, responseCode: ''));
      }
    }));
  }

  Future<void> _logOut(
      LogOutEvent event, Emitter<BaseState<UserState>> emit) async {
    emit(APILoadingState());
    final result = await repository.logOutAPI();
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
        return LogOutSuccessState();
      } else {
        return APIFailureState(
            errorResponseModel:
                ErrorResponseModel(responseError: r.message, responseCode: ''));
      }
    }));
  }

  Future<void> _userRegister(
      UserRegisterEvent event, Emitter<BaseState<UserState>> emit) async {
    emit(APILoadingState());
    final result = await repository.userRegisterAPI(UserRegisterRequest(
      email: event.email,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
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
        return UserRegisterSuccessState();
      } else {
        return APIFailureState(
            errorResponseModel:
                ErrorResponseModel(responseError: r.message, responseCode: ''));
      }
    }));
  }
}
