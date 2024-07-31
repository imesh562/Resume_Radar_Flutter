part of 'user_bloc.dart';

@immutable
abstract class UserState extends BaseState<UserState> {}

class UserInitial extends UserState {}

class LoginSuccessState extends UserState {}

class AuthUserSuccessState extends UserState {
  final AuthUser authUser;

  AuthUserSuccessState({required this.authUser});
}

class SendOtpSuccessUserState extends UserState {
  final bool isSent;
  final String message;

  SendOtpSuccessUserState({
    required this.isSent,
    required this.message,
  });
}

class VerifyOtpSuccessUserState extends UserState {}

class VerifyOtpFailedUserState extends UserState {
  final String message;

  VerifyOtpFailedUserState({required this.message});
}

class LogOutSuccessState extends UserState {}

class UserRegisterSuccessState extends UserState {}
