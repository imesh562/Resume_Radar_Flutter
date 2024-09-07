import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:resume_radar/app/resume_radar_app.dart';
import 'package:resume_radar/utils/enums.dart';
import 'package:sharpapi_flutter_client/sharpapi_flutter_client.dart';

import '../core/configurations/app_config.dart';
import '../core/service/dependency_injection.dart' as di;
import '../core/service/notification_provider.dart';
import '../utils/app_constants.dart';
import 'flavor_config.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  SharpApiConfigs.init(
    apiKey: 'V6QagNCLUbR2sgGTwPjvqVlKXwfOB7jDgbjTemB0',
  );

  Gemini.init(apiKey: AppConstants.API_KEY);

  FlavorConfig(
      flavor: Flavor.PROD, color: Colors.black38, flavorValues: FlavorValues());

  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.deviceOS == DeviceOS.ANDROID) {
    await Firebase.initializeApp();
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      log('Firebase : ${e.toString()}');
    }
  } else {}

  await di.setupLocator();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
  ;

  runApp(
    DevicePreview(
      enabled: kIsWeb,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
          child: ResumeRadarApp(),
        );
      },
    ),
  );
}
