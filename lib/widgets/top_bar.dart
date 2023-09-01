import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:easytech_electric_blue/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sensors_plus/sensors_plus.dart';
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

class MovingAverage {
  final int size;
  final List<double> values;
  int pointer = 0;
  double sum = 0;

  MovingAverage(this.size) : values = List.filled(size, 0.0);

  void addValue(double value) {
    sum -= values[pointer];
    values[pointer] = value;
    sum += value;
    pointer = (pointer + 1) % size;
  }

  double get average => sum / size;
}

class TopTab extends StatefulWidget {
  const TopTab({
    super.key,
  });

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> with WidgetsBindingObserver {
  bool isMoving = false;
  MovingAverage movingAverage = MovingAverage(4);
  int countMoving = 0;
  bool isFirstTime = true;
  Timer? timer;
  int countMessage = -1;
  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;

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

  void getBatteryInfo() async {
    battery["level"] = await Battery().batteryLevel;
    battery["state"] = await Battery().onBatteryStateChanged.first;
    if (mounted) {
      setState(() {
        battery["level"];
        battery["state"];
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer!.cancel();
    accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    StorageManager().save();
    getDate();
    getBatteryInfo();

    accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (seedDropControl['enabled'] &&
          antenna['speed'] < 1 &&
          !seedDropControl["isControlling"]) {
        // Get the value of acceleration in the desired axis, in this case, x
        double currentValue = event.z;
        // print("ACELEROMETRO: $event");

        // If the last value is available, compare it with the current value
        if (seedDropControl['lastValue'] != null) {
          double difference = currentValue - seedDropControl['lastValue'];

          // If the difference is greater than the threshold, consider it as movement
          if (difference.abs() > seedDropControl['calibration']) {
            // print('Movement detected!');
            seedDropManager.update(1);
            seedDropControl["isControlling"] = true;
            Messages().message["fillDisk"]!(1);
            machine['diskFilling'] = true;
            Timer(const Duration(seconds: 5), () {
              seedDropControl["isControlling"] = false;
              machine['diskFilling'] = false;
              Messages().message["fillDisk"]!(0);
              seedDropManager.update(0);
            });
          } else {
            seedDropControl["isControlling"] = false;
          }
        }
      }
    });

    timer ??= Timer.periodic(const Duration(seconds: 3), (timer) async {
      getDate();
      getBatteryInfo();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      LockTask.disable();
      status['minimized'] = true;
      AppLogger.log('TIMER PAUSED');
      // await Future.delayed(const Duration(seconds: 1));

      timer!.cancel();
    } else {
      LockTask.enable();
      status['minimized'] = false;
      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.route, (route) => false);
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
                Text(
                  "${battery["level"]}%",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: kPrimaryColor),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14, top: 5),
                      child: Container(
                        width: 24 * battery["level"] / 100,
                        height: 12,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:
                                BorderRadius.circular(kDefaultBorderSize / 5)),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                      child: SvgPicture.asset(
                        'assets/icons/battery.svg',
                      ),
                    ),
                    battery["state"] == BatteryState.charging
                        ? Positioned(
                            left: -2,
                            right: 0,
                            top: 4.5,
                            child: SizedBox(
                              height: 13,
                              child: SvgPicture.asset(
                                'assets/icons/bolt.svg',
                              ),
                            ),
                          )
                        : const SizedBox(),
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
