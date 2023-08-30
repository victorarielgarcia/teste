import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
import '../utilities/constants/colors.dart';
import '../utilities/messages.dart';
import '../widgets/adjust_card.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/config_card.dart';
import '../widgets/top_bar.dart';
import 'fertilizer_calibration_screen.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});
  static const String route = '/fertilizer';

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 40);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: JMBottomNavigationBar(
        onExit: () {
          Messages().message["fertilizer"]!();
          AppLogger.log("SEND CONFIGURATIONS: $fertilizer");
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
              const Text(
                "Configurações Adubo",
                style: TextStyle(
                    fontSize: 22,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: kDefaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const ConfigCard(
                        id: 10,
                        title: 'Taxa desejada',
                        unit: 'kg/ha',
                        min: 30,
                        max: 1500,
                        step: 10,
                      ),
                      AdjustCard(
                        id: 1,
                        title: 'Constante de peso',
                        unit: 'g/volta',
                        buttonText: 'Calibrar',
                        onTap: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                FertilizerCalibrationScreen.route,
                                (route) => false),
                      ),
                    ],
                  ),
                  const SizedBox(width: kDefaultPadding),
                  const Column(
                    children: [
                      ConfigCard(
                        id: 12,
                        title: 'Relação de engrenagens',
                        unit: '',
                        min: 0.1,
                        max: 10.01,
                        step: 0.1,
                        decimalPoint: 3,
                        integer: false,
                      ),
                      // ConfigCard(
                      //   id: 13,
                      //   title: 'Limite de erro RPM - Verde',
                      //   unit: '%',
                      //   min: 2,
                      //   max: 20,
                      //   step: 0.1,
                      //   integer: false,
                      // ),
                      // ConfigCard(
                      //   id: 14,
                      //   title: 'Limite de erro RPM - Amarelo',
                      //   unit: '%',
                      //   min: 5,
                      //   max: 30,
                      //   step: 0.1,
                      //   integer: false,
                      // ),
                      ConfigCard(
                        id: 15,
                        title: 'Compensação de erro',
                        unit: '%',
                        min: -20,
                        max: 20,
                        step: 1,
                        integer: false,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
