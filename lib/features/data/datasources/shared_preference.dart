import 'package:shared_preferences/shared_preferences.dart';

const String _APP_TOKEN = 'app_token';
const String _PUSH_TOKEN = 'push_token';

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
}
