import 'dart:async';

import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/utilities/messages.dart';

class FillDiskTimer {
  static final FillDiskTimer _singleton = FillDiskTimer._internal();
  Timer? _timer;



  factory FillDiskTimer() {
    return _singleton;
  }

  FillDiskTimer._internal();

  void startTimer() {
    _timer = Timer(const Duration(seconds: 7), () {
      motor['targetRPMSeed'] = 0;
      machine['diskFilling'] = false;
      Messages().message["fillDisk"]!(0);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
