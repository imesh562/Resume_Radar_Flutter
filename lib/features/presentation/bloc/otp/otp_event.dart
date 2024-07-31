part of 'otp_bloc.dart';

@immutable
abstract class OtpEvent extends BaseEvent {}

class SendOtpEvent extends OtpEvent {
  final String email;
  final bool isForgotPassword;

  SendOtpEvent({
    required this.email,
    this.isForgotPassword = false,
  });
}

class VerifyOtpEvent extends OtpEvent {
  final String email;
  final String otp;

  VerifyOtpEvent({
    required this.email,
    required this.otp,
  });
}

class CheckEmailEvent extends OtpEvent {
  final String email;

  CheckEmailEvent({
    required this.email,
  });
}
