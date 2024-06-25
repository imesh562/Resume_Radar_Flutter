import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/service/dependency_injection.dart';
import '../core/service/local_push_manager.dart';
import '../core/service/notification_provider.dart';
import '../features/data/datasources/shared_preference.dart';
import '../flavors/flavor_config.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/navigation_routes.dart';

class ResumeRadarApp extends StatefulWidget {
  @override
  State<ResumeRadarApp> createState() => _ResumeRadarAppState();
}

class _ResumeRadarAppState extends State<ResumeRadarApp> {
  final appSharedData = injection<AppSharedData>();
  final localPushManager = LocalPushManager.init();

  @override
  void initState() {
    super.initState();
    _fetchPushID();
    if (!AppConstants.isPushServiceInitialized) {
      AppConstants.isPushServiceInitialized = true;
      _configureFirebaseNotification();
    }
  }

  _configureFirebaseNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleFCM(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        localPushManager.showNotification(LocalNotification(
            title: message.notification!.title!,
            body: message.notification!.body!));
      }

      _handleFCM(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleFCM(message);
    });
  }

  _handleFCM(RemoteMessage message) {
    Provider.of<NotificationProvider>(context, listen: false)
        .triggerNotificationCallback();
  }

  _fetchPushID() async {
    if (!appSharedData.hasPushToken()) {
      if (appSharedData.getPushToken()!.isEmpty) {
        FirebaseMessaging.instance.getToken().then((token) {
          if (token != null) {
            log(token ?? '');
            appSharedData.setPushToken(token ?? '');
          }
        });
      }
    }
    log("Token: ${appSharedData.getPushToken()}");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: !FlavorConfig.isProduction(),
            title: AppConstants.appName,
            initialRoute: Routes.kSplashView,
            onGenerateRoute: Routes.generateRoute,
            theme: ThemeData(
                primaryColor: AppColors.primaryGreen,
                textTheme: GoogleFonts.workSansTextTheme().copyWith(
                  bodyText2:
                      GoogleFonts.workSansTextTheme().bodyText2?.copyWith(
                            letterSpacing: -0.5,
                          ),
                ),
                scaffoldBackgroundColor: AppColors.colorWhite),
          );
        });
  }
}
