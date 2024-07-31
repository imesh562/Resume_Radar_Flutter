part of 'user_bloc.dart';

@immutable
abstract class UserEvent extends BaseEvent {}

class UserLoginEvent extends UserEvent {
  final bool shouldShowProgress;
  final String userName;
  final String password;
  final bool rememberMe;

  UserLoginEvent({
    this.shouldShowProgress = true,
    required this.userName,
    required this.password,
    required this.rememberMe,
  });
}

class AuthUserEvent extends UserEvent {
  final bool shouldShowProgress;
  final bool? isSplashView;
  AuthUserEvent({
    this.shouldShowProgress = true,
    this.isSplashView,
  });
}

class SendOtpUserEvent extends UserEvent {
  final String email;
  final bool isForgotPassword;

  SendOtpUserEvent({
    required this.email,
    this.isForgotPassword = false,
  });
}

class VerifyOtpUserEvent extends UserEvent {
  final String email;
  final String otp;

  VerifyOtpUserEvent({
    required this.email,
    required this.otp,
  });
}

class LogOutEvent extends UserEvent {}

class UserRegisterEvent extends UserEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  UserRegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}
