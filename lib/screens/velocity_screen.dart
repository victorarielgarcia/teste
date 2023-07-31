
import 'package:flutter/material.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/config_card.dart';
import '../widgets/simple_card.dart';
import '../widgets/top_bar.dart';

class VelocityScreen extends StatefulWidget {
  const VelocityScreen({super.key});
  static const String route = '/velocity';

  @override
  State<VelocityScreen> createState() => _VelocityScreenState();
}

class _VelocityScreenState extends State<VelocityScreen> {
  final nmeaState = nmeaManager.state;
  void nmeaListener() {
    if (mounted) {
      setState(() {
        nmeaState;
      });
    }
  }

  final antennaState = antennaManager.state;
  void antennaListener() {
    if (mounted) {
      setState(() {
        antennaState;
      });
    }
  }

  @override
  void initState() {
    nmeaManager.addListener(nmeaListener);
    antennaManager.addListener(antennaListener);
    if (connected) {
      Bluetooth().currentScreen(context, 60);
    }

    super.initState();
  }

  @override
  void dispose() {
    nmeaManager.removeListener(nmeaListener);
    antennaManager.removeListener(antennaListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: JMBottomNavigationBar(
        onExit: () {
          Messages().message["velocity"]!();
          AppLogger.log("SEND CONFIGURATIONS: $velocity, NMEA: $nmea");
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
                "Configurações Velocidade",
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
                        velocity['options'] = 1;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          color: velocity['options'] == 1
                              ? kPrimaryColor
                              : Colors.white,
                          border: Border.all(color: kStrokeColor),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(kDefaultBorderSize),
                            topLeft: Radius.circular(kDefaultBorderSize),
                          )),
                      child: Center(
                          child: Text(
                        "Antena SVA",
                        style: TextStyle(
                            color: velocity['options'] == 1
                                ? Colors.white
                                : kPrimaryColor,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       velocity['options'] = 2;
                  //     });
                  //   },
                  //   child: Container(
                  //     width: 150,
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       color: velocity['options'] == 2
                  //           ? kPrimaryColor
                  //           : Colors.white,
                  //       border: Border.all(color: kStrokeColor),
                  //     ),
                  //     child: Center(
                  //         child: Text(
                  //       "Nmea",
                  //       style: TextStyle(
                  //           color: velocity['options'] == 2
                  //               ? Colors.white
                  //               : kPrimaryColor,
                  //           // fontSize: 28,
                  //           fontWeight: FontWeight.w500),
                  //     )),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        velocity['options'] = 3;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          color: velocity['options'] == 3
                              ? kPrimaryColor
                              : Colors.white,
                          border: Border.all(color: kStrokeColor),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(kDefaultBorderSize),
                            bottomRight: Radius.circular(kDefaultBorderSize),
                          )),
                      child: Center(
                          child: Text(
                        "Simulação",
                        style: TextStyle(
                            color: velocity['options'] == 3
                                ? Colors.white
                                : kPrimaryColor,
                            // fontSize: 28,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                  ),
                ],
              ),
              velocity['options'] == 1
                  ? Column(
                      children: [
                        SimpleCard(
                          title: 'Velocidade',
                          text: '${antennaState.speed}',
                          unit: 'km/h',
                        ),
                        const ConfigCard(
                          id: 23,
                          title: 'Compensação de erro',
                          unit: '%',
                          min: -20,
                          max: 20,
                          step: 1,
                          decimalPoint: 0,
                          integer: false,
                        ),
                      ],
                    )
                  : velocity['options'] == 2
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    SimpleCard(
                                      title: 'Velocidade',
                                      text: nmeaState.latitude == 0.0
                                          ? 'Aguardando...'
                                          : nmeaState.satelliteSpeed
                                              .toStringAsFixed(2),
                                      unit: nmeaState.latitude == 0.0
                                          ? ''
                                          : 'km/h',
                                      textFontSize:
                                          nmeaState.latitude == 0.0 ? 22 : 34,
                                    ),
                                    SimpleCard(
                                      title: 'Qualidade do sinal',
                                      text: nmeaState.latitude == 0.0
                                          ? 'Aguardando...'
                                          : nmeaState.qualitySignal == 1
                                              ? 'Standalone'
                                              : nmeaState.qualitySignal == 2
                                                  ? 'DGPS'
                                                  : nmeaState.qualitySignal == 3
                                                      ? 'RTK fixed'
                                                      : 'RTK float',
                                      textFontSize: 22,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: kDefaultPadding / 2),
                                Column(
                                  children: [
                                    SimpleCard(
                                        title: 'Coordenadas',
                                        textFontSize: 22,
                                        text: nmeaState.latitude == 0.0
                                            ? 'Aguardando...'
                                            : '${nmeaState.latitude.toStringAsFixed(5)} , ${nmeaState.longitude.toStringAsFixed(5)}'),
                                    SimpleCard(
                                      title: 'Número de satelites',
                                      text: nmeaState.numberOfSatellites
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const ConfigCard(
                              id: 23,
                              title: 'Compensação de erro',
                              unit: '%',
                              min: -20,
                              max: 20,
                              step: 1,
                              decimalPoint: 0,
                              integer: false,
                            ),
                          ],
                        )
                      : const Column(
                          children: [
                            ConfigCard(
                              id: 22,
                              title: 'Velocidade Simulada',
                              unit: 'km/h',
                              min: 0.5,
                              max: 20,
                              step: 0.1,
                              integer: false,
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
