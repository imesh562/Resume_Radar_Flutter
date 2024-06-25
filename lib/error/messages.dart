import 'failures.dart';

class ErrorMessages {
  ///error_title
  static const String TITLE_ERROR = "Error";
  static const String TITLE_SUCCESS = "Success";
  static const String TITLE_UPDATE = "Update";
  static const String TITLE_QUESTION = "Confirm";

  ///error_messages
  static const String ERROR_CONNECTION =
      "Connection error.\nPlease check your internet connectivity";
  static const String ERROR_SOMETHING_WENT_WRONG =
      "Oops, Something went wrong!";
  static const String ERROR_APP_VERIFICATION_FAILED =
      "App verification failed!";

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ConnectionFailure:
        return 'No internet connection detected.';
      case ServerFailure:
        return (failure as ServerFailure).errorResponse.responseError ??
            'Unexpected error';
      case AuthorizedFailure:
        return 'Unauthorized User';
      default:
        return 'Unexpected error';
    }
  }
}
