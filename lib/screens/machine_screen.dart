import 'package:easytech_electric_blue/screens/sections_layout_screen.dart';
import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:easytech_electric_blue/utilities/messages.dart';
import 'package:easytech_electric_blue/widgets/button.dart';
import 'package:easytech_electric_blue/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';
import '../widgets/adjust_card.dart';
import '../widgets/boolean_card.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/config_card.dart';
import '../widgets/top_bar.dart';
import 'machine_layout_screen.dart';

class MachineScreen extends StatefulWidget {
  const MachineScreen({super.key});
  static const String route = '/machine';

  @override
  State<MachineScreen> createState() => _MachineScreenState();
}

class _MachineScreenState extends State<MachineScreen> {
  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 10);
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
          Messages().message['machine']!();
          AppLogger.log("SEND CONFIGURATIONS: $machine");
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
                "Configurações Plantadeira",
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
                        id: 1,
                        title: 'Número de linhas',
                        unit: 'linhas',
                        min: 1,
                        max: 36,
                      ),
                      const ConfigCard(
                        id: 2,
                        title: 'Espaçamento',
                        unit: 'cm',
                        min: 10,
                        max: 150,
                      ),
                      AdjustCard(
                        id: 4,
                        title: 'Número de seções',
                        unit: '',
                        buttonText: 'Configurar',
                        onTap: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                SectionsLayoutScreen.route, (route) => false),
                      ),
                      // ConfigCard(
                      //   id: 3,
                      //   title: 'Número de seções',
                      //   unit: '',
                      //   min: 1,
                      //   max: 3,
                      // ),
                    ],
                  ),
                  const SizedBox(width: kDefaultPadding),
                  Column(
                    children: [
                      const BooleanCard(
                        id: 1,
                        title: 'Adubo',
                        smallSize: true,
                      ),
                      const SizedBox(width: kDefaultPadding / 2),
                      const BooleanCard(
                        id: 2,
                        title: 'Braquiaria',
                        smallSize: true,
                      ),
                      const SizedBox(width: kDefaultPadding / 2),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: kDefaultPadding / 2),
                        child: JMCard(
                          height: 170,
                          width: 160,
                          body: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0, kDefaultPadding / 2, 0, kDefaultPadding / 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Layout",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18),
                                ),
                                SvgPicture.asset(
                                  'assets/icons/planter_machine.svg',
                                  height: 45,
                                  colorFilter: ColorFilter.mode(
                                    kPrimaryColor.withOpacity(0.6),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding / 4),
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: 45,
                                      child: JMButton(
                                          text: 'Configurar',
                                          onPressed: () {
                                            if (machine['brachiaria'] ||
                                                machine['fertilizer']) {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      MachineLayoutScreen.route,
                                                      (route) => false);
                                            }
                                          })),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
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
