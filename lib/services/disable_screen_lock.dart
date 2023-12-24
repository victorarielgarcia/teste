// import 'package:flutter/services.dart';
// import 'logger.dart';

// const platform = MethodChannel('samples.flutter.dev/lockTask');

// class DisableScreenLock {
//   static void enable() async {
//     try {
//       await platform.invokeMethod('setMaximumTimeToLock');
//       LockButtonInterceptor.interceptLockButton();
//     } on PlatformException catch (e) {
//       AppLogger.log("Failed to set maximum time to lock: '${e.message}'.");
//     }
//   }
// }
