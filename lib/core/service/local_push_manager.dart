import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final int id;
  final String title;
  final String body;
  final String? payload;

  LocalNotification(
      {this.id = 0, required this.title, required this.body, this.payload});
}

class LocalPushManager {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late String _timezone;

  LocalPushManager.init() {
    _init();
  }

  _init() async {
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) async {
      LocalNotification notification = LocalNotification(
          id: id, title: title ?? '', body: body ?? '', payload: payload);
      showNotification(notification);
    });

    final _initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
    );
  }

  Future<void> showNotification(LocalNotification localNotification) async {
    var androidChannel = const AndroidNotificationDetails(
        'Dazhboard', 'Dazhboard', // description
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        enableLights: true,
        playSound: true);

    var platformChannel = NotificationDetails(
      android: androidChannel,
    );
    await _flutterLocalNotificationsPlugin.show(localNotification.id,
        localNotification.title, localNotification.body, platformChannel);
  }

  cancelNotificationByID(int id) {
    _flutterLocalNotificationsPlugin.cancel(id);
  }

  cancelAllNotifications() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}
