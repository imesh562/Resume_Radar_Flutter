import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../error/exceptions.dart' as EXC;
import '../../error/messages.dart';
import '../../features/data/datasources/shared_preference.dart';
import '../../features/data/models/common/common_error_response.dart';
import 'network_config.dart';

class APIHelper {
  final Dio dio;
  final AppSharedData appSharedData;

  APIHelper({required this.dio, required this.appSharedData}) {
    _initApiClient();
  }

  _initApiClient() {
    final logInterceptor = LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      error: kDebugMode,
      requestHeader: kDebugMode,
      responseHeader: kDebugMode,
    );

    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(milliseconds: CONNECT_TIMEOUT),
      receiveTimeout: const Duration(milliseconds: RECEIVE_TIMEOUT),
      baseUrl: NetworkConfig.getNetworkUrl(),
      contentType: 'application/json',
    );

    dio
      ..options = options
      ..interceptors.add(logInterceptor);

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }

  Future<dynamic> get(String url) async {
    try {
      if (appSharedData.getAppToken() != null) {
        dio.options.headers["Authorization"] =
            "Bearer ${appSharedData.getAppToken() ?? ''}";
      }

      final response = await dio.get(
        NetworkConfig.getNetworkUrl() + url,
      );
      log("Response: $response");
      return response;
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode != null) {
        final int statusCode = e.response!.statusCode!;

        if (statusCode < 200 || statusCode > 400) {
          switch (statusCode) {
            case 401:
            case 403:
              throw EXC.UnAuthorizedException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 404:
            case 500:
              throw EXC.ServerException(ErrorResponseModel(
                  responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                  responseCode: ''));
            default:
              throw EXC.DioException(
                  errorResponseModel: ErrorResponseModel(
                      responseCode: e.response!.statusCode.toString(),
                      responseError: e.response!.statusMessage!));
          }
        }
      } else {
        throw EXC.ServerException(ErrorResponseModel(
            responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
            responseCode: ''));
      }
    }
  }

  Future<dynamic> post(String url, {@required body}) async {
    try {
      if (appSharedData.getAppToken() != null) {
        dio.options.headers["Authorization"] =
            "Bearer ${appSharedData.getAppToken() ?? ''}";
      }

      final response = await dio.post(
        NetworkConfig.getNetworkUrl() + url,
        data: body,
      );
      log("Response: $response");
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        final int statusCode = e.response!.statusCode!;

        if (statusCode < 200 || statusCode > 400) {
          switch (statusCode) {
            case 401:
            case 403:
              throw EXC.UnAuthorizedException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 404:
            case 500:
              throw EXC.ServerException(ErrorResponseModel(
                  responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                  responseCode: ''));
            default:
              throw EXC.DioException(
                  errorResponseModel: ErrorResponseModel(
                      responseCode: e.response!.statusCode.toString(),
                      responseError: e.response!.statusMessage!));
          }
        }
      } else {
        throw EXC.ServerException(ErrorResponseModel(
            responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
            responseCode: ''));
      }
    }
  }
}
