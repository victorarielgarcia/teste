
import 'package:easytech_electric_blue/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import '../services/bluetooth.dart';
import '../services/lock_task.dart';
import '../services/storage_manager.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';
import '../widgets/loading.dart';

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
    // const AndroidIntent(
    //   action: 'android.settings.BLUETOOTH_SETTINGS',
    // ).launch();
    _init();
  }

  _init() async {
  
    LockTask.enable();
    Wakelock.enable();
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
    if (!mounted) return;
    await Navigator.pushNamedAndRemoveUntil(
        context, WorkScreen.route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Loading(),
      ),
    );
  }
}
