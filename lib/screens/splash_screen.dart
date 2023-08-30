import 'package:easytech_electric_blue/screens/work_screen.dart';
import 'package:easytech_electric_blue/services/main_timer.dart';
import 'package:easytech_electric_blue/services/geolocation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock/wakelock.dart';
import '../services/bluetooth.dart';
import '../services/lock_task.dart';
import '../services/storage_manager.dart';
import '../utilities/global.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/';
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    MainTimer().stopTimer();
    await Geolocation.init();
    LockTask.enable();
    Wakelock.enable();
    VolumeController().listener((volume) {
      if (volume < 1.0) {
        VolumeController().maxVolume();
      }
    });
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      await StorageManager().save();
      await StorageManager().load();
      await prefs.setBool('isFirstTime', false);
    } else {
      await StorageManager().load();
    }
    await soundManager.init();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    Bluetooth().connect();
    MainTimer().startTimer();
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        settings: const RouteSettings(name: WorkScreen.route),
        transitionDuration: const Duration(seconds: 3),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(opacity: animation, child: const WorkScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
            height: 85, child: Image.asset('assets/images/logo_jumil2.png')),
      ),
    );
  }
}
