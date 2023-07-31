import 'package:flutter/services.dart';
import 'logger.dart';

const platform = MethodChannel('samples.flutter.dev/lockTask');

class LockTask {
  static void disable() async {
    try {
      await platform.invokeMethod('unlockTaskMode');
    } on PlatformException catch (e) {
      AppLogger.log("Failed to unlock task mode: '${e.message}'.");
    }
  }

  static void enable() async {
    try {
      await platform.invokeMethod('lockTaskMode');
    } on PlatformException catch (e) {
      AppLogger.log("Failed to lock task mode: '${e.message}'.");
    }
  }
}
