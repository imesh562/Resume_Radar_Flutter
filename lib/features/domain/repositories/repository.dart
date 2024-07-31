import 'package:dartz/dartz.dart';

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
}
