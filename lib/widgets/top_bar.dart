import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/bluetooth.dart';
import '../services/lock_task.dart';
import '../services/logger.dart';
import '../services/storage_manager.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: kDefaultPadding),
                  child: SizedBox(
                      height: 45,
                      width: 185,
                      child: Image.asset('assets/images/logo_jumil.png'))),
              const TopTab(),
              const TopIcons(),
            ],
          ),
        ),
      ],
    );
  }
}

class TopTab extends StatefulWidget {
  const TopTab({
    super.key,
  });

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> with WidgetsBindingObserver {
  Timer? timer;
  int countMessage = -1;

  int batteryLevel = 0;
  int day = 0;
  int month = 0;
  int year = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;

  void getDate() {
    var date = DateTime.now();
    setState(() {
      day = date.day;
      month = date.month;
      year = date.year;
      hour = date.hour;
      minute = date.minute;
      second = date.second;
    });
  }

  void getBatteryLevel() async {
    batteryLevel = await Battery().batteryLevel;
    setState(() {
      batteryLevel;
    });
  }

  void saveData() async {
    await StorageManager().save();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    saveData();
    getDate();
    getBatteryLevel();

    timer ??= Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!sendWithQueue && connected) {
        if (sendManutenceMessage) {
          // Messages().message["setMotors"]!();
          Messages().message["antennaAndLiftSensorModule"]!();
          // await Bluetooth().send(0, 1, 0, Messages().kManutenceMessage, 1);
        }
      }
      // bluetoothManager.changeConnectionState(checkConnection);
      checkConnection = false;
      sendManutenceMessage = true;
      if (!connected) {
        Bluetooth().connect();
      }
      getDate();
      getBatteryLevel();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      LockTask.disable();
      AppLogger.log('TIMER PAUSED');
      // await Future.delayed(const Duration(seconds: 1));

      timer!.cancel();
    } else {
      LockTask.enable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        width: 800,
        height: 70,
        decoration: BoxDecoration(
            color: kSecondaryColor,
            border: Border.all(color: kStrokeColor),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(kDefaultBorderSize),
                bottomRight: Radius.circular(kDefaultBorderSize))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: kPrimaryColor),
                    ),
                    Text(
                      "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: kPrimaryColor),
                    ),
                  ],
                ),
                const SizedBox(
                  width: kDefaultPadding * 1.5,
                ),
                // SizedBox(
                //   height: 35,
                //   child: SvgPicture.asset(
                //     'assets/icons/alert.svg',
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 7.0, top: 3.5),
                      child: Container(
                        color: kPrimaryColor,
                        width: 28 * batteryLevel / 100,
                        height: 13,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: SvgPicture.asset(
                        'assets/icons/battery.svg',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: kDefaultPadding,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TopIcons extends StatefulWidget {
  const TopIcons({
    super.key,
  });

  @override
  State<TopIcons> createState() => _TopIconsState();
}

class _TopIconsState extends State<TopIcons> {
  final bluetoothState = bluetoothManager.state;
  void bluetoothListener() {
    if (mounted) {
      setState(() {
        bluetoothState;
      });
    }
  }

  final liftSensorState = liftSensorManager.state;
  void liftSensorListener() {
    if (mounted) {
      setState(() {
        liftSensorState;
      });
    }
  }

  @override
  void initState() {
    bluetoothManager.addListener(bluetoothListener);
    liftSensorManager.addListener(liftSensorListener);
    super.initState();
  }

  @override
  void dispose() {
    bluetoothManager.removeListener(bluetoothListener);
    liftSensorManager.removeListener(liftSensorListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
      child: SizedBox(
        width: 185,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 30,
              child: SvgPicture.asset(
                liftSensorState.machineLifted
                    ? 'assets/icons/machine_down.svg'
                    : 'assets/icons/machine_up.svg',
                colorFilter: ColorFilter.mode(
                  liftSensorState.color,
                  BlendMode.srcIn,
                ),
              ),
            ),
            // const SizedBox(width: kDefaultPadding / 4),
            // SizedBox(
            //   height: 30,
            //   child: SvgPicture.asset(
            //     'assets/icons/gps.svg',
            //     colorFilter:
            //         const ColorFilter.mode(kDisabledColor, BlendMode.srcIn),
            //   ),
            // ),
            const SizedBox(width: kDefaultPadding / 4),
            SizedBox(
              height: 30,
              child: SvgPicture.asset(
                'assets/icons/bluetooth.svg',
                colorFilter: ColorFilter.mode(
                    bluetoothState.connected ? Colors.blue : kDisabledColor,
                    BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
