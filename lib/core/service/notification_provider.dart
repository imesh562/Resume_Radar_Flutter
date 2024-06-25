import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  // Callback function that can be set and called when needed
  VoidCallback? notificationCallback;
  int notificationCount = 0;

  // Function to trigger the callback
  void triggerNotificationCallback() {
    notificationCallback?.call();
    notificationCount++;
    notifyListeners();
  }

  clearNotificationCount() {
    notificationCount = 0;
    notifyListeners();
  }

  setNotificationCount(int count) {
    notificationCount = count;
    notifyListeners();
  }
}
