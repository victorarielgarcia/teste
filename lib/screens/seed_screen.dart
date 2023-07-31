
import 'package:flutter/material.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/config_card.dart';
import '../widgets/top_bar.dart';

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});
  static const String route = '/seed';

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  @override
  void initState() {
    // PROVISORIO

    if (connected) {
      Bluetooth().currentScreen(context, 30);
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
          Messages().message["seed"]!();
          AppLogger.log("SEND CONFIGURATIONS: $seed");
        },
      ),
      appBar:
          const PreferredSize(preferredSize: Size(800, 70), child: TopBar()),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Configurações Semente",
                style: TextStyle(
                    fontSize: 22,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(height: kDefaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ConfigCard(
                        id: 4,
                        title: 'Taxa desejada',
                        unit: 'sem/m',
                        min: 0.5,
                        max: 70,
                        step: 0.1,
                        decimalPoint: 1,
                        integer: false,
                      ),
                      ConfigCard(
                        id: 5,
                        title: 'Número de furos',
                        unit: 'furos',
                        min: 3,
                        max: 200,
                      ),
                      ConfigCard(
                        id: 6,
                        title: 'Relação de engrenagens',
                        unit: '',
                        min: 0.05,
                        max: 10.01,
                        step: 0.1,
                        decimalPoint: 3,
                        integer: false,
                      ),
                    ],
                  ),
                  SizedBox(width: kDefaultPadding),
                  Column(
                    children: [
                      ConfigCard(
                        id: 7,
                        title: 'Limite de erro - Verde',
                        unit: '%',
                        min: 2,
                        max: 20,
                        step: 0.1,
                        integer: false,
                      ),
                      ConfigCard(
                        id: 8,
                        title: 'Limite de erro - Amarelo',
                        unit: '%',
                        min: 5,
                        max: 30,
                        step: 0.1,
                        integer: false,
                      ),
                      ConfigCard(
                        id: 9,
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
