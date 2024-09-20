import 'package:dartz/dartz.dart';
import 'package:resume_radar/features/data/models/requests/check_email_request.dart';
import 'package:resume_radar/features/data/models/requests/get_questions_data_request.dart';
import 'package:resume_radar/features/data/models/requests/get_quizzes_request.dart';
import 'package:resume_radar/features/data/models/requests/user_register_request.dart';
import 'package:resume_radar/features/data/models/responses/check_email_response.dart';
import 'package:resume_radar/features/data/models/responses/get_questions_data_responses.dart';
import 'package:resume_radar/features/data/models/responses/get_quizzes_response.dart';
import 'package:resume_radar/features/data/models/responses/user_register_response.dart';

import '../../../error/failures.dart';
import '../../data/models/requests/login_request.dart';
import '../../data/models/requests/send_otp_request.dart';
import '../../data/models/requests/verify_otp_request.dart';
import '../../data/models/responses/auth_user_response.dart';
import '../../data/models/responses/log_out_response.dart';
import '../../data/models/responses/login_response.dart';
import '../../data/models/responses/send_otp_response.dart';
import '../../data/models/responses/verify_otp_response.dart';

abstract class Repository {
  Future<Either<Failure, LoginResponse>> loginRequest(
      LoginRequest loginRequest);

  Future<Either<Failure, AuthUserResponse>> authUserRequest();

  Future<Either<Failure, SendOtpResponse>> sendOtpRequest(
      SendOtpRequest sendOtpRequest);

  Future<Either<Failure, VerifyOtpResponse>> verifyOtpRequest(
      VerifyOtpRequest verifyOtpRequest);

  Future<Either<Failure, LogOutResponse>> logOutAPI();

  Future<Either<Failure, CheckEmailResponse>> checkEmailAPI(
      CheckEmailRequest checkEmailRequest);

  Future<Either<Failure, UserRegisterResponse>> userRegisterAPI(
      UserRegisterRequest userRegisterRequest);

  Future<Either<Failure, GetQuizzesResponse>> getQuizzesAPI(
      GetQuizzesRequest getQuizzesRequest);

  Future<Either<Failure, GetQuestionDataResponse>> getQuestionsDataAPI(
      GetQuestionDataRequest getQuestionDataRequest);
}
