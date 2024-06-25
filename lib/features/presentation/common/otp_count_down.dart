import 'dart:async';

class OTPCountDown {
  late String _countDown;
  late Timer _timer;

  OTPCountDown.startOTPTimer({
    required int timeInMS,
    required void currentCountDown(String countDown),
    required void onFinish(),
  }) {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      timeInMS -= 1000;
      Duration duration = Duration(milliseconds: timeInMS);

      if (duration.inSeconds % 60 == 0) {
        _countDown = "0${duration.inMinutes}:00";
      } else {
        int seconds = duration.inSeconds % 60;
        String secondsInString = seconds.toString();
        if (seconds < 10) {
          secondsInString = "0$seconds";
        }
        _countDown = "0${duration.inMinutes}:$secondsInString";
      }

      currentCountDown(_getCountDown);

      if (duration.inSeconds == 0) {
        onFinish();
        timer.cancel();
      }
    });
  }

  String get _getCountDown => _countDown;

  void cancelTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }
}
