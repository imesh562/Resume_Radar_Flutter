import 'package:dartz/dartz.dart';
import 'package:resume_radar/features/data/models/requests/check_email_request.dart';
import 'package:resume_radar/features/data/models/requests/get_questions_data_request.dart';
import 'package:resume_radar/features/data/models/requests/get_quizzes_request.dart';
import 'package:resume_radar/features/data/models/requests/user_register_request.dart';
import 'package:resume_radar/features/data/models/responses/check_email_response.dart';
import 'package:resume_radar/features/data/models/responses/get_questions_data_responses.dart';
import 'package:resume_radar/features/data/models/responses/get_quizzes_response.dart';
import 'package:resume_radar/features/data/models/responses/user_register_response.dart';

import '../../../core/network/network_info.dart';
import '../../../error/exceptions.dart';
import '../../../error/failures.dart';
import '../../../error/messages.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/common/common_error_response.dart';
import '../models/requests/login_request.dart';
import '../models/requests/send_otp_request.dart';
import '../models/requests/verify_otp_request.dart';
import '../models/responses/auth_user_response.dart';
import '../models/responses/log_out_response.dart';
import '../models/responses/login_response.dart';
import '../models/responses/send_otp_response.dart';
import '../models/responses/verify_otp_response.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, LoginResponse>> loginRequest(
      LoginRequest loginRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.loginRequest(loginRequest);
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUserResponse>> authUserRequest() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.authUserRequest();
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, SendOtpResponse>> sendOtpRequest(
      SendOtpRequest sendOtpRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendOtpRequest(sendOtpRequest);
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, VerifyOtpResponse>> verifyOtpRequest(
      VerifyOtpRequest confirmOtpRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.verifyOtpRequest(confirmOtpRequest);
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, LogOutResponse>> logOutAPI() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.logOutAPI();
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, CheckEmailResponse>> checkEmailAPI(
      CheckEmailRequest checkEmailRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.checkEmailAPI(checkEmailRequest);
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, UserRegisterResponse>> userRegisterAPI(
      UserRegisterRequest userRegisterRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.registerUserAPI(userRegisterRequest);
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, GetQuestionDataResponse>> getQuestionsDataAPI(
      GetQuestionDataRequest getQuestionDataRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.getQuestionDataAPI(getQuestionDataRequest);
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, GetQuizzesResponse>> getQuizzesAPI(
      GetQuizzesRequest getQuizzesRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.getQuizzesAPI(getQuizzesRequest);
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
