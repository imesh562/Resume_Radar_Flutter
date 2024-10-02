import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';

import '../models/responses/auth_user_response.dart';

const String _APP_TOKEN = 'app_token';
const String _EMAIL_KEY = 'email_key';
const String _PW_KEY = 'password_key';
const String _PUSH_TOKEN = 'push_token';
const String _REMEMBER_KEY = 'remember_key';
const String _APP_USER = 'app_user';
const String _Mock_Interview_Data = 'mock_interview_data';
const String _Resume_Analysis_Data = 'resume_analysis_data';

class AppSharedData {
  late SharedPreferences secureStorage;

  AppSharedData(SharedPreferences preferences) {
    secureStorage = preferences;
  }

  ///APP TOKEN
  bool hasAppToken() {
    return secureStorage.containsKey(_APP_TOKEN);
  }

  setAppToken(String token) {
    secureStorage.setString(_APP_TOKEN, token);
  }

  String? getAppToken() {
    if (secureStorage.containsKey(_APP_TOKEN)) {
      return secureStorage.getString(_APP_TOKEN);
    } else {
      return "";
    }
  }

  clearAppToken() {
    secureStorage.remove(_APP_TOKEN);
  }

  ///SET EMAIL
  bool hasEmail() {
    return secureStorage.containsKey(_EMAIL_KEY);
  }

  setEmail(String token) {
    secureStorage.setString(_EMAIL_KEY, token);
  }

  String? getEmail() {
    if (secureStorage.containsKey(_EMAIL_KEY)) {
      return secureStorage.getString(_EMAIL_KEY);
    } else {
      return "";
    }
  }

  clearEmail() {
    secureStorage.remove(_EMAIL_KEY);
  }

  ///SET PW
  bool hasPassword() {
    return secureStorage.containsKey(_PW_KEY);
  }

  setPassword(String token) {
    secureStorage.setString(_PW_KEY, token);
  }

  String? getPassword() {
    if (secureStorage.containsKey(_PW_KEY)) {
      return secureStorage.getString(_PW_KEY);
    } else {
      return "";
    }
  }

  clearPW() {
    secureStorage.remove(_PW_KEY);
  }

  ///REMEMBER ME
  setRememberMe(bool remember) {
    secureStorage.setBool(_REMEMBER_KEY, remember);
  }

  bool getRememberMe() {
    if (secureStorage.containsKey(_REMEMBER_KEY)) {
      return secureStorage.getBool(_REMEMBER_KEY)!;
    } else {
      return false;
    }
  }

  bool hasRememberMe() {
    return secureStorage.containsKey(_REMEMBER_KEY);
  }

  ///PUSH TOKEN
  setPushToken(String token) {
    secureStorage.setString(_PUSH_TOKEN, token);
  }

  bool hasPushToken() {
    return secureStorage.containsKey(_PUSH_TOKEN);
  }

  String? getPushToken() {
    if (secureStorage.containsKey(_PUSH_TOKEN)) {
      return secureStorage.getString(_PUSH_TOKEN);
    } else {
      return "";
    }
  }

  clearPushToken() {
    secureStorage.remove(_PUSH_TOKEN);
  }

  ///Auth User
  setAppUser(AuthUser authUser) {
    secureStorage.setString(_APP_USER, jsonEncode(authUser.toJson()));
  }

  bool hasAppUser() {
    return secureStorage.containsKey(_APP_USER);
  }

  AuthUser getAppUser() {
    return AuthUser.fromJson(jsonDecode(secureStorage.getString(_APP_USER)!));
  }

  clearAppUser() {
    secureStorage.remove(_APP_USER);
  }

  ///Mock Interview
  setMockInterviewData(List<Map<String, dynamic>> mockInterviewData) {
    secureStorage.setString(
        _Mock_Interview_Data, jsonEncode(mockInterviewData));
  }

  bool hasMockInterviewData() {
    return secureStorage.containsKey(_Mock_Interview_Data);
  }

  List<Map<String, dynamic>> getMockInterviewData() {
    List<Map<String, dynamic>> interviewData = List<Map<String, dynamic>>.from(
        jsonDecode(secureStorage.getString(_Mock_Interview_Data)!));
    return interviewData;
  }

  clearMockInterviewData() {
    secureStorage.remove(_Mock_Interview_Data);
  }

  ///Resume Analysis
  setResumeAnalysisData(List<ParseResumeModel> mockInterviewData) {
    secureStorage.setString(
        _Resume_Analysis_Data,
        jsonEncode(
            List<dynamic>.from(mockInterviewData.map((x) => x.toJson()))));
  }

  bool hasResumeAnalysisData() {
    return secureStorage.containsKey(_Resume_Analysis_Data);
  }

  List<ParseResumeModel> getResumeAnalysisData() {
    return List<ParseResumeModel>.from(
        jsonDecode(secureStorage.getString(_Resume_Analysis_Data)!)
            .map((x) => ParseResumeModel.fromJson(x)));
  }

  clearResumeAnalysisData() {
    secureStorage.remove(_Resume_Analysis_Data);
  }
}
