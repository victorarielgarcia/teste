import 'package:easytech_electric_blue/screens/fertilizer_screen.dart';
import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:easytech_electric_blue/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
import '../utilities/constants/colors.dart';
import '../utilities/messages.dart';
import '../widgets/back_button.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/config_card.dart';
import '../widgets/top_bar.dart';
import 'fertilizer_calibration_result_screen.dart';

class FertilizerCalibrationScreen extends StatefulWidget {
  const FertilizerCalibrationScreen({super.key});
  static const String route = '/fertilizer/calibration';

  @override
  State<FertilizerCalibrationScreen> createState() =>
      _FertilizerCalibrationScreenState();
}

class _FertilizerCalibrationScreenState
    extends State<FertilizerCalibrationScreen> with TickerProviderStateMixin {
  int fillRotor = 0;
  bool isCollecting = false;
  late AnimationController controller;

  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 100);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (isCollecting) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: JMBottomNavigationBar(
        onExit: () {
          AppLogger.log("SEND CONFIGURATIONS: $fertilizer");
          Messages().message["calibration"]!(0);
        },
      ),
      appBar:
          const PreferredSize(preferredSize: Size(800, 70), child: TopBar()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Calibração Adubo",
                        style: TextStyle(
                            fontSize: 22,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  JMBackButton(
                    onPressed: () {
                      Messages().message["calibration"]!(false);
                      return Navigator.of(context).pushNamedAndRemoveUntil(
                          FertilizerScreen.route, (route) => false);
                    },
                  ),
                ],
              ),
              isCollecting
                  ? Padding(
                      padding: const EdgeInsets.all(kDefaultPadding * 6),
                      child: Column(
                        children: [
                          const Text(
                            "Coletando...",
                            style: TextStyle(
                                fontSize: 20,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(height: kDefaultPadding),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(kDefaultBorderSize * 2)),
                                child: LinearProgressIndicator(
                                  value: controller.value,
                                  backgroundColor: kStrokeColor,
                                  color: kSuccessColor,
                                  minHeight: 50,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "${((controller.value * 100).toInt())}%",
                                    style: const TextStyle(
                                      inherit: true,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: kBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kDefaultPadding),
                          SizedBox(
                            width: 200,
                            height: 60,
                            child: JMButton(
                              onPressed: () {
                                controller.stop();
                                setState(() {
                                  isCollecting = false;
                                });
                              },
                              text: "Cancelar",
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: kDefaultPadding),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    const ConfigCard(
                                      id: 11,
                                      title: 'Constante de peso',
                                      unit: 'g/volta',
                                      min: 10,
                                      max: 99,
                                      step: 0.1,
                                      decimalPoint: 1,
                                      integer: false,
                                    ),
                                    SizedBox(
                                      width: 320,
                                      height: 170,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: ClipOval(
                                            child: Material(
                                              color: kPrimaryColor,
                                              child: InkWell(
                                                splashColor: kSecondaryColor,
                                                onTap: () async {
                                                  setState(() {
                                                    fertilizer[
                                                        'constantWeight'] = 48;
                                                  });
                                                  await Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          FertilizerCalibrationScreen
                                                              .route,
                                                          (route) => false);
                                                },
                                                child: const SizedBox(
                                                    width: 35,
                                                    height: 35,
                                                    child: Icon(Icons.restore,
                                                        color: kSecondaryColor,
                                                        size: 18)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ConfigCard(
                                  id: 24,
                                  title: 'Número motor',
                                  unit: '',
                                  min: 1,
                                  max: 60,
                                  step: 1,
                                ),
                                SizedBox(width: kDefaultPadding / 2),
                                ConfigCard(
                                  id: 25,
                                  title: 'RPM para calibrar',
                                  unit: 'RPM',
                                  min: 5,
                                  max: 500,
                                  step: 5,
                                ),
                                SizedBox(width: kDefaultPadding / 2),
                                ConfigCard(
                                  id: 26,
                                  title: 'Número de voltas',
                                  unit: 'voltas',
                                  min: 1,
                                  max: 50,
                                  step: 1,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: kDefaultPadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 110,
                              height: 80,
                              child: JMButton(
                                backgroundColor: fillRotor == 1
                                    ? kSuccessColor
                                    : kPrimaryColor,
                                onPressed: () {
                                  setState(() {
                                    fillRotor == 0
                                        ? fillRotor = 1
                                        : fillRotor = 0;
                                  });
                                  Messages().message["calibration"]!(fillRotor);
                                },
                                text: "",
                                icon: SvgPicture.asset(
                                  'assets/icons/screw_thread.svg',
                                  height: 25,
                                  colorFilter: ColorFilter.mode(
                                    kBackgroundColor.withOpacity(0.9),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: kDefaultPadding / 2),
                            SizedBox(
                              width: 250,
                              height: 80,
                              child: JMButton(
                                onPressed: () {
                                  Messages().message["calibration"]!(0);

                                  controller = AnimationController(
                                    vsync: this,
                                    duration: const Duration(seconds: 5),
                                  )..addListener(() {
                                      if (controller.value == 1) {
                                        calibration['calibrationResult'] = 0;
                                        calibration['collectedWeight'] = 0;
                                        calibration['numberOfLinesCollected'] =
                                            1;
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            FertilizerCalibrationResultScreen
                                                .route,
                                            (route) => false);
                                      }
                                      setState(() {});
                                    });
                                  controller.forward();
                                  setState(() {
                                    isCollecting = true;
                                  });
                                },
                                text: "Iniciar Coleta",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
