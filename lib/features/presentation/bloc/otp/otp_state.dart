part of 'otp_bloc.dart';

@immutable
abstract class OtpState extends BaseState<OtpState> {}

class OtpInitial extends OtpState {}

class SendOtpSuccessState extends OtpState {
  final bool isSent;
  final String message;

  SendOtpSuccessState({
    required this.isSent,
    required this.message,
  });
}

class VerifyOtpSuccessState extends OtpState {}

class VerifyOtpFailedState extends OtpState {
  final String message;

  VerifyOtpFailedState({required this.message});
}

class CheckEmailSuccessState extends OtpState {}
