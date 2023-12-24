import 'package:easytech_electric_blue/services/speed.dart';
import 'package:flutter/material.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/motor_info_card.dart';
import '../widgets/top_bar.dart';

class MotorScreen extends StatefulWidget {
  const MotorScreen({super.key});
  static const String route = '/motor';

  @override
  State<MotorScreen> createState() => _MotorScreenState();
}

class _MotorScreenState extends State<MotorScreen> {
  final motorState = motorManager.state;

  void motorListener() {
    if (mounted) {
      setState(() {
        motorState.rpm;
      });
    }
  }

  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 99);
    }
    motorManager.addListener(motorListener);

    // if (systemSimulationMode) {
    //   refreshState();
    // }
    super.initState();
  }

  // Future<dynamic> refreshState() async {
  //   if (mounted) {
  //     double speed = Speed.getCurrentVelocity();
  //     if (speed > 0) {
  //       if (machine['diskFilling']) {
  //         motor['targetRPMSeed'] = 10.0;
  //       } else {
  //         motor['targetRPMSeed'] =
  //             ((seed['desiredRate'] / seed['numberOfHoles']) *
  //                 (speed / 3.6) *
  //                 60);
  //       }

  //       motor['targetRPMFertilizer'] = (((fertilizer['desiredRate'] /
  //                       (10000 / machine['spacing']) /
  //                       fertilizer['constantWeight']) *
  //                   (speed / 3.6) *
  //                   60) *
  //               10) /
  //           fertilizer['gearRatio'];

  //       motor['targetRPMBrachiaria'] = (((brachiaria['desiredRate'] /
  //                       (10000 / machine['spacing']) /
  //                       brachiaria['constantWeight']) *
  //                   (speed / 3.6) *
  //                   60) *
  //               10) /
  //           brachiaria['gearRatio'];

  //       for (var i = 0; i < brachiaria['layout'].length; i++) {
  //         motor['rpm'][brachiaria['addressedLayout'][i] - 1] =
  //             motor['targetRPMBrachiaria'] +
  //                 (Random().nextInt(10).toDouble() / 19.4);
  //       }
  //       for (var i = 0; i < fertilizer['layout'].length; i++) {
  //         motor['rpm'][fertilizer['addressedLayout'][i] - 1] =
  //             motor['targetRPMFertilizer'] +
  //                 (Random().nextInt(10).toDouble() / 19.4);
  //       }
  //       for (var i = 0; i < machine['numberOfLines']; i++) {
  //         motor['rpm'][seed['addressedLayout'][i] - 1] =
  //             motor['targetRPMSeed'] + (Random().nextInt(10).toDouble() / 19.4);
  //       }
  //       motorManager.updateRPM(
  //         motor['rpm'],
  //         motor['targetRPMBrachiaria'],
  //         motor['targetRPMFertilizer'],
  //         motor['targetRPMSeed'],
  //       );
  //       await Future<dynamic>.delayed(
  //         const Duration(seconds: 1),
  //       );

  //       await refreshState();
  //     }
  //   }
  // }

  @override
  void dispose() {
    motorManager.removeListener(motorListener);
    super.dispose();
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
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                !machine['brachiaria']
                    ? const SizedBox()
                    : Column(
                        children: [
                          const SizedBox(height: kDefaultPadding / 2),
                          Text(
                            "Braquiária (RPM alvo: ${motorState.targetRPMBrachiaria.toStringAsFixed(2)})",
                            style: const TextStyle(
                              fontSize: 18,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: kDefaultPadding / 1.5,
                            runSpacing: kDefaultPadding / 1.5,
                            children: List.generate(brachiaria['layout'].length,
                                (index) {
                              double rpmCurrent = motorState.rpm[
                                  brachiaria['addressedLayout'][index] - 1];
                              double rpmTarget = motorState.targetRPMBrachiaria;
                              int error = 0;
                              if (rpmCurrent == 0) {
                                error = -1;
                              } else {
                                double percentageDifference =
                                    ((rpmCurrent - rpmTarget).abs() /
                                            rpmTarget) *
                                        100;

                                if (percentageDifference < 5) {
                                  error = 0;
                                } else if (percentageDifference >= 5 &&
                                    percentageDifference < 10) {
                                  error = 1;
                                } else if (percentageDifference >= 10) {
                                  error = 2;
                                }
                              }
                              // else if (percentageDifference >= 20) {
                              //   error = 3;
                              // }
                              double speed = Speed.getCurrentVelocity();

                              if (speed == 0 && rpmCurrent < 1) {
                                error = -1;
                              }
                              return SizedBox(
                                width: 90,
                                height: 70,
                                child: MotorInfoCard(
                                  name: 'Braquiária',
                                  index: index,
                                  value: rpmCurrent,
                                  error: error,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                !machine['fertilizer']
                    ? const SizedBox()
                    : Column(children: [
                        const SizedBox(height: kDefaultPadding),
                        Text(
                          "Adubo (RPM alvo: ${motorState.targetRPMFertilizer.toStringAsFixed(2)})",
                          style: const TextStyle(
                            fontSize: 18,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: kDefaultPadding / 2),
                        Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          spacing: kDefaultPadding / 1.5,
                          runSpacing: kDefaultPadding / 1.5,
                          children: List.generate(fertilizer['layout'].length,
                              (index) {
                            double rpmCurrent = motorState
                                .rpm[fertilizer['addressedLayout'][index] - 1];
                            double rpmTarget = motorState.targetRPMFertilizer;
                            int error = 0;
                            if (rpmCurrent == 0) {
                              error = -1;
                            } else {
                              double percentageDifference =
                                  ((rpmCurrent - rpmTarget).abs() / rpmTarget) *
                                      100;

                              if (percentageDifference < 5) {
                                error = 0;
                              } else if (percentageDifference >= 5 &&
                                  percentageDifference < 10) {
                                error = 1;
                              } else if (percentageDifference >= 10) {
                                error = 2;
                              }
                              // if (percentageDifference >= 5 &&
                              //     percentageDifference < 10) {
                              //   error = 0;
                              // } else if (percentageDifference >= 10 &&
                              //     percentageDifference < 15) {
                              //   error = 1;
                              // } else if (percentageDifference >= 15) {
                              //   error = 2;
                              // }
                            }
                            // else if (percentageDifference >= 20) {
                            //   error = 3;
                            // }
                            double speed = Speed.getCurrentVelocity();

                            if (speed == 0 && rpmCurrent < 1) {
                              error = -1;
                            }
                            return SizedBox(
                              width: 90,
                              height: 70,
                              child: MotorInfoCard(
                                name: 'Adubo',
                                index: index,
                                value: rpmCurrent,
                                error: error,
                              ),
                            );
                          }),
                        ),
                      ]),
                Column(children: [
                  const SizedBox(height: kDefaultPadding),
                  Text(
                    "Semente (RPM alvo: ${motorState.targetRPMSeed.toStringAsFixed(2)})",
                    style: const TextStyle(
                      fontSize: 18,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing: kDefaultPadding / 1.5,
                    runSpacing: kDefaultPadding / 1.5,
                    children: List.generate(machine['numberOfLines'], (index) {
                      double rpmCurrent =
                          motorState.rpm[seed['addressedLayout'][index] - 1];
                      double rpmTarget = motorState.targetRPMSeed;
                      int error = 0;
                      if (rpmCurrent == 0) {
                        error = -1;
                      } else {
                        double percentageDifference =
                            ((rpmCurrent - rpmTarget).abs() / rpmTarget) * 100;
                        if (percentageDifference < 5) {
                          error = 0;
                        } else if (percentageDifference >= 5 &&
                            percentageDifference < 10) {
                          error = 1;
                        } else if (percentageDifference >= 10) {
                          error = 2;
                        }
                      }
                      // else if (percentageDifference >= 20) {
                      //   error = 3;
                      // }
                      double speed = Speed.getCurrentVelocity();
                      if (speed == 0 && rpmCurrent < 1) {
                        error = -1;
                      }
                      return SizedBox(
                        width: 90,
                        height: 70,
                        child: MotorInfoCard(
                          name: 'Semente',
                          index: index,
                          value: rpmCurrent,
                          error: error,
                        ),
                      );
                    }),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
