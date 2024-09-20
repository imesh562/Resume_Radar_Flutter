import 'dart:core';

import 'package:resume_radar/features/data/datasources/shared_preference.dart';
import 'package:resume_radar/features/data/models/requests/check_email_request.dart';
import 'package:resume_radar/features/data/models/requests/get_questions_data_request.dart';
import 'package:resume_radar/features/data/models/requests/get_quizzes_request.dart';
import 'package:resume_radar/features/data/models/requests/user_register_request.dart';
import 'package:resume_radar/features/data/models/responses/check_email_response.dart';
import 'package:resume_radar/features/data/models/responses/get_questions_data_responses.dart';
import 'package:resume_radar/features/data/models/responses/get_quizzes_response.dart';
import 'package:resume_radar/features/data/models/responses/user_register_response.dart';

import '../../../core/network/api_helper.dart';
import '../models/requests/login_request.dart';
import '../models/requests/send_otp_request.dart';
import '../models/requests/verify_otp_request.dart';
import '../models/responses/auth_user_response.dart';
import '../models/responses/log_out_response.dart';
import '../models/responses/login_response.dart';
import '../models/responses/send_otp_response.dart';
import '../models/responses/verify_otp_response.dart';

abstract class RemoteDataSource {
  Future<LoginResponse> loginRequest(LoginRequest loginRequest);

  Future<AuthUserResponse> authUserRequest();

  Future<SendOtpResponse> sendOtpRequest(SendOtpRequest sendOtpRequest);

  Future<VerifyOtpResponse> verifyOtpRequest(VerifyOtpRequest verifyOtpRequest);

  Future<LogOutResponse> logOutAPI();

  Future<UserRegisterResponse> registerUserAPI(
      UserRegisterRequest userRegisterRequest);

  Future<CheckEmailResponse> checkEmailAPI(CheckEmailRequest checkEmailRequest);

  Future<GetQuizzesResponse> getQuizzesAPI(GetQuizzesRequest getQuizzesRequest);

  Future<GetQuestionDataResponse> getQuestionDataAPI(
      GetQuestionDataRequest getQuestionDataRequest);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final APIHelper apiHelper;
  final AppSharedData appSharedData;

  RemoteDataSourceImpl({required this.apiHelper, required this.appSharedData});

  @override
  Future<LoginResponse> loginRequest(LoginRequest loginRequest) async {
    try {
      final response = await apiHelper.post(
        "login",
        body: loginRequest.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<AuthUserResponse> authUserRequest() async {
    try {
      final response = await apiHelper.get(
        "userData",
      );
      return AuthUserResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<SendOtpResponse> sendOtpRequest(
    SendOtpRequest sendOtpRequest,
  ) async {
    try {
      final response = await apiHelper.post(
        "send_otp",
        body: sendOtpRequest.toJson(),
      );
      return SendOtpResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<VerifyOtpResponse> verifyOtpRequest(
      VerifyOtpRequest verifyOtpRequest) async {
    try {
      final response = await apiHelper.post(
        "verify_otp",
        body: verifyOtpRequest.toJson(),
      );
      return VerifyOtpResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<LogOutResponse> logOutAPI() async {
    try {
      final response = await apiHelper.post(
        "logout",
      );
      return LogOutResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CheckEmailResponse> checkEmailAPI(
      CheckEmailRequest checkEmailRequest) async {
    try {
      final response = await apiHelper.post(
        "check_email",
        body: checkEmailRequest.toJson(),
      );
      return CheckEmailResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<UserRegisterResponse> registerUserAPI(
      UserRegisterRequest userRegisterRequest) async {
    try {
      final response = await apiHelper.post(
        "register",
        body: userRegisterRequest.toJson(),
      );
      return UserRegisterResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<GetQuizzesResponse> getQuizzesAPI(
      GetQuizzesRequest getQuizzesRequest) async {
    try {
      final response = await apiHelper.get(
        "quizzes?page=${getQuizzesRequest.page}&perPage=${getQuizzesRequest.perPage}&sort=${getQuizzesRequest.sort}",
      );
      return GetQuizzesResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<GetQuestionDataResponse> getQuestionDataAPI(
      GetQuestionDataRequest getQuestionDataRequest) async {
    try {
      final response = await apiHelper.get(
        "quizzes/${getQuestionDataRequest.quizId}/questions",
      );
      return GetQuestionDataResponse.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }
}
