import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../widgets/adjust_card.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/config_card.dart';
import '../widgets/top_bar.dart';
import 'brachiaria_calibration_screen.dart';

class BrachiariaScreen extends StatefulWidget {
  const BrachiariaScreen({super.key});
  static const String route = '/brachiaria';

  @override
  State<BrachiariaScreen> createState() => _BrachiariaScreenState();
}

class _BrachiariaScreenState extends State<BrachiariaScreen> {
  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 50);
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
          Messages().message["brachiaria"]!();
          AppLogger.log("SEND CONFIGURATIONS: $brachiaria");
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
                "Configurações Braquiária",
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
                        id: 16,
                        title: 'Taxa desejada',
                        unit: 'kg/ha',
                        min: 1,
                        max: 20,
                        step: 0.1,
                        integer: false,
                      ),
                      AdjustCard(
                        id: 2,
                        title: 'Constante de peso',
                        unit: 'g/volta',
                        buttonText: 'Calibrar',
                        onTap: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                BrachiariaCalibrationScreen.route,
                                (route) => false),
                      ),
              
                      const ConfigCard(
                        id: 18,
                        title: 'Relação de engrenagens',
                        unit: '',
                        min: 0.1,
                        max: 5,
                        step: 0.1,
                        integer: false,
                      ),
                    ],
                  ),
                  const SizedBox(width: kDefaultPadding),
                  const Column(
                    children: [
                      ConfigCard(
                        id: 19,
                        title: 'Limite de erro RPM - Verde',
                        unit: '%',
                        min: 2,
                        max: 20,
                        step: 0.1,
                        integer: false,
                      ),
                      ConfigCard(
                        id: 20,
                        title: 'Limite de erro RPM - Amarelo',
                        unit: '%',
                        min: 5,
                        max: 30,
                        step: 0.1,
                        integer: false,
                      ),
                      ConfigCard(
                        id: 21,
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
