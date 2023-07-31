
import 'package:flutter/material.dart';
import '../models/lift_sensor_model.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../widgets/boolean_card.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/top_bar.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});
  static const String route = '/sensor';

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 70);
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
          Messages().message["sensor"]!(LiftSensor().getSelectableOption());
          AppLogger.log("SEND CONFIGURATIONS: $liftSensor ");
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
                "Configurações Sensores",
                style: TextStyle(
                    fontSize: 22,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        liftSensor = {
                          'options': 1,
                          'normallyOpen': false,
                          'manualMachineLifted': false,
                        };
                      });
                    },
                    child: Container(
                      width: 160,
                      height: 50,
                      decoration: BoxDecoration(
                          color: liftSensor['options'] == 1
                              ? kPrimaryColor
                              : Colors.white,
                          border: Border.all(color: kStrokeColor),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(kDefaultBorderSize),
                            topLeft: Radius.circular(kDefaultBorderSize),
                          )),
                      child: Center(
                          child: Text(
                        "Sensor Levante",
                        style: TextStyle(
                            color: liftSensor['options'] == 1
                                ? Colors.white
                                : kPrimaryColor,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        liftSensor = {
                          'options': 2,
                          'normallyOpen': false,
                          'manualMachineLifted': true,
                        };
                      });
                    },
                    child: Container(
                      width: 160,
                      height: 50,
                      decoration: BoxDecoration(
                        color: liftSensor['options'] == 2
                            ? kPrimaryColor
                            : Colors.white,
                        border: Border.all(color: kStrokeColor),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(kDefaultBorderSize),
                            bottomRight: Radius.circular(kDefaultBorderSize)),
                      ),
                      child: Center(
                          child: Text(
                        "Manual",
                        style: TextStyle(
                            color: liftSensor['options'] == 2
                                ? Colors.white
                                : kPrimaryColor,
                            // fontSize: 28,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                  ),
                ],
              ),
              liftSensor['options'] == 1
                  ? const Column(
                      children: [
                        BooleanCard(
                          id: 3,
                          title: 'Normalmente aberto',
                          secondTitle: 'Normalmente fechado',
                        ),
                      ],
                    )
                  : liftSensor['options'] == 2
                      ? const Column(
                          children: [
                            BooleanCard(
                              id: 4,
                              title: 'Máquina levantada',
                              secondTitle: 'Máquina abaixada',
                            ),
                          ],
                        )
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
