import 'package:easytech_electric_blue/screens/brachiaria_calibration_result_screen.dart';
import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:easytech_electric_blue/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../utilities/messages.dart';
import '../widgets/back_button.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/config_card.dart';
import '../widgets/top_bar.dart';
import 'brachiaria_screen.dart';

class BrachiariaCalibrationScreen extends StatefulWidget {
  const BrachiariaCalibrationScreen({super.key});
  static const String route = '/brachiaria/calibration';

  @override
  State<BrachiariaCalibrationScreen> createState() =>
      _BrachiariaCalibrationScreenState();
}

class _BrachiariaCalibrationScreenState
    extends State<BrachiariaCalibrationScreen> {
  int fillRotor = 0;
  bool isCollecting = false;
  int porcentage = 0;
  final calibrationState = calibrationManager.state;

  void calibrationListener() {
    setState(() {
      porcentage = calibrationState.porcentage;
    });
    if (porcentage == 100) {
      calibration['calibrationResult'] = 0;
      calibration['collectedWeight'] = 0;
      calibration['numberOfLinesCollected'] = 1;
      Messages().message["calibration"]!(0, 2);
      Navigator.pushNamedAndRemoveUntil(
          context, BrachiariaCalibrationResultScreen.route, (route) => false);
    }
  }

  @override
  void initState() {
    calibrationManager.addListener(calibrationListener);
    if (connected) {
      Bluetooth().currentScreen(context, 100);
    }
    super.initState();
  }

  @override
  void dispose() {
    calibrationManager.removeListener(calibrationListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: JMBottomNavigationBar(
        onExit: () {
          Messages().message["calibration"]!(0, 2);
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
                        "Calibração Braquiária",
                        style: TextStyle(
                            fontSize: 24,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  JMBackButton(
                    onPressed: () {
                      Messages().message["calibration"]!(0, 2);
                      return Navigator.of(context).pushNamedAndRemoveUntil(
                          BrachiariaScreen.route, (route) => false);
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
                                fontSize: 22,
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
                                  value: porcentage / 100,
                                  backgroundColor: kStrokeColor,
                                  color: kSuccessColor,
                                  minHeight: 50,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "${((porcentage).toInt())}%",
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
                                Messages().message["calibration"]!(0, 2);
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
                                      id: 17,
                                      title: 'Constante de peso',
                                      unit: 'g/volta',
                                      min: 1,
                                      max: 50,
                                      step: 0.1,
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
                                                    brachiaria[
                                                        'constantWeight'] = 5;
                                                  });
                                                  await Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          BrachiariaCalibrationScreen
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ConfigCard(
                                  id: 24,
                                  title: 'Número motor',
                                  unit: '',
                                  min: 1,
                                  max: brachiaria['layout'].length.toDouble(),
                                  step: 1,
                                ),
                                const SizedBox(width: kDefaultPadding / 2),
                                const ConfigCard(
                                  id: 25,
                                  title: 'RPM para calibrar',
                                  unit: 'RPM',
                                  min: 5,
                                  max: 500,
                                  step: 5,
                                ),
                                const SizedBox(width: kDefaultPadding / 2),
                                const ConfigCard(
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
                                  Messages().message["calibration"]!(
                                      fillRotor, 2);
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
                                  Messages().message["calibration"]!(2, 2);
                                  setState(() {
                                    isCollecting = true;
                                    porcentage = 0;
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
