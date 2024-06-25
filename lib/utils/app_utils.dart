import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static TimeOfDay getTimeFromString(String time) {
    return TimeOfDay(
        hour: int.parse(time.split(':')[0]),
        minute: int.parse(time.split(':')[1].split(' ')[0]));
  }

  static String convertTimeOfDayToAPIFormat(TimeOfDay value) {
    return '${value.hour}:${value.minute}:00';
  }

  static String convertTimeToAPIFormat(String value) {
    final time = getTimeFromString(value);
    return convertTimeOfDayToAPIFormat(time);
  }

  static String convertToCurrency(double amount,
      {bool shouldAddSymbol = true}) {
    return '${shouldAddSymbol ? 'Rs ' : ''}${NumberFormat.currency(symbol: '').format(amount)}';
  }
}
