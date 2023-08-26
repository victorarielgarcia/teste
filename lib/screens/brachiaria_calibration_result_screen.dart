import 'dart:async';

import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../utilities/messages.dart';
import '../widgets/adjust_card.dart';
import '../widgets/back_button.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/button.dart';
import '../widgets/config_card.dart';
import '../widgets/top_bar.dart';
import 'brachiaria_calibration_screen.dart';
import 'brachiaria_screen.dart';

class BrachiariaCalibrationResultScreen extends StatefulWidget {
  const BrachiariaCalibrationResultScreen({super.key});
  static const String route = '/brachiaria/calibration/result';

  @override
  State<BrachiariaCalibrationResultScreen> createState() =>
      _BrachiariaCalibrationResultScreenState();
}

class _BrachiariaCalibrationResultScreenState
    extends State<BrachiariaCalibrationResultScreen> {
  double constantWeight = 0.0;

  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 100);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: JMBottomNavigationBar(
        onExit: () {},
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
                            fontSize: 22,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  JMBackButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            BrachiariaCalibrationScreen.route,
                            (route) => false),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: kDefaultPadding),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: kDefaultPadding),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConfigCard(
                            id: 27,
                            title: 'Peso coletado',
                            unit: 'g',
                            min: 50,
                            max: 10000,
                            step: 1,
                          ),
                          SizedBox(width: kDefaultPadding / 2),
                          ConfigCard(
                            id: 28,
                            title: 'Número de linhas coletadas',
                            unit: 'linhas',
                            min: 1,
                            max: 3,
                            step: 1,
                          ),
                          SizedBox(width: kDefaultPadding / 2),
                        ],
                      ),
                      const SizedBox(height: kDefaultPadding),
                      SizedBox(
                        width: 250,
                        height: 80,
                        child: JMButton(
                          onPressed: () {
                            constantWeight = double.parse((calibration[
                                        'collectedWeight'] /
                                    (calibration['numberOfLaps'] *
                                        calibration['numberOfLinesCollected']))
                                .toStringAsFixed(2));

                            // Dar mensagem de erro se não for de 10 a 100 g/voltas no adubo

                            // Dar mensagem de erro se não for de 1 a 50 g/voltas na braquiaria

                            calibration['calibrationResult'] = constantWeight;
                            Timer(const Duration(milliseconds: 350), () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  BrachiariaCalibrationResultScreen.route,
                                  (route) => false);
                            });
                          },
                          text: "Calcular",
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: kDefaultPadding),
                  AdjustCard(
                    id: 5,
                    title: 'Resultado',
                    unit: 'g/volta',
                    buttonText: 'Aplicar',
                    onTap: () async {
                      brachiaria['constantWeight'] =
                          calibration['calibrationResult'];
                      Messages().message["brachiaria"]!();
                      if (mounted) {
                        await Navigator.of(context).pushNamedAndRemoveUntil(
                            BrachiariaScreen.route, (route) => false);
                      }
                    },
                  ),
                  // const JMCard(
                  //   height: 120,
                  //   width: 250,
                  //   body: Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.fromLTRB(
                  //             0, kDefaultPadding / 2, 0, kDefaultPadding / 4),
                  //         child: Text(
                  //           'Resultado',
                  //           style: const TextStyle(
                  //               color: kPrimaryColor,
                  //               fontWeight: FontWeight.w300,
                  //               fontSize: 18),
                  //         ),
                  //       ),
                  //       Text(
                  //         '48.5',
                  //         style: const TextStyle(
                  //             color: kPrimaryColor,
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 34),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
