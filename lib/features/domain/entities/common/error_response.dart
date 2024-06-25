import 'package:equatable/equatable.dart';

class ErrorResponse extends Equatable {
  ErrorResponse({
    this.responseCode,
    this.responseError,
    this.isSuceess,
  });

  String? responseCode;
  String? responseError;
  bool? isSuceess;

  @override
  List<Object> get props => [responseError ?? "", responseCode ?? ""];
}
