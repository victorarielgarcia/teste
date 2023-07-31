import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../widgets/back_button.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';
import '../widgets/dialogs/machine_layout_dialog.dart';
import '../widgets/dialogs/module_addressing_dialog.dart';
import '../widgets/top_bar.dart';
import 'advanced_screen.dart';

class MotorAddressingScreen extends StatefulWidget {
  const MotorAddressingScreen({super.key});
  static const String route = '/advanced/motor/addressing';

  @override
  State<MotorAddressingScreen> createState() => _MotorAddressingScreenState();
}

class _MotorAddressingScreenState extends State<MotorAddressingScreen> {
  Timer? timer;
  bool disableNavigation = false;
  bool isAddressing = false;
  int lastState = -1;
  int motorID = 0;
  int timerCount = 0;

  bool checkMaxNumberOfLines(List<int> section) {
    int count = 0;
    bool condition = false;
    for (var element in section) {
      count += element;
    }
    count < machine["numberOfLines"] ? condition = false : condition = true;
    return condition;
  }

  void checkLayout() {
    if (!checkMaxNumberOfLines(brachiaria["layout"]) ||
        !checkMaxNumberOfLines(fertilizer["layout"])) {
      setState(() {
        disableNavigation = true;
      });
    } else {
      setState(() {
        disableNavigation = false;
      });
    }
  }

  void cancelAddressing() {
    for (var i = 0; i < brachiaria['addressed'].length; i++) {
      if (brachiaria['addressed'][i] == -1) {
        setState(() {
          brachiaria['addressed'][i] = 0;
        });
      }
    }
    for (var i = 0; i < fertilizer['addressed'].length; i++) {
      if (fertilizer['addressed'][i] == -1) {
        setState(() {
          fertilizer['addressed'][i] = 0;
        });
      }
    }
    for (var i = 0; i < seed['addressed'].length; i++) {
      if (seed['addressed'][i] == -1) {
        setState(() {
          seed['addressed'][i] = 0;
        });
      }
    }
    timerCount = 0;
    isAddressing = false;
    Messages().message["motorAddressing"]!(0);
  }

  void motorAddressingListener() {
    if (mounted) {
      setState(() {
        brachiaria['addressed'] =
            motorAddressingManager.state.brachiariaAddressed;
        fertilizer['addressed'] =
            motorAddressingManager.state.fertilizerAddressed;
        seed['addressed'] = motorAddressingManager.state.seedAddressed;
      });
      cancelAddressing();
    }
  }

  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 22);
    }

    motorAddressingManager.addListener(motorAddressingListener);
    timer ??= Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (isAddressing) {
        Messages().message["moduleAddressing"]!(motorID);
        timerCount++;
      }
      if (timerCount == 360) {
        cancelAddressing();
        moduleAddresingDialog(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    motorAddressingManager.removeListener(motorAddressingListener);
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: Stack(
        children: [
          JMBottomNavigationBar(
            onExit: () {
              cancelAddressing();
            },
          ),
          disableNavigation
              ? GestureDetector(
                  onTap: () {
                    machineLayoutDialog(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    color: Colors.transparent,
                  ),
                )
              : const SizedBox()
        ],
      ),
      appBar:
          const PreferredSize(preferredSize: Size(800, 70), child: TopBar()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Endereçamento dos motores",
                          style: TextStyle(
                              fontSize: 22,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    JMBackButton(
                      onPressed: () {
                        if (!disableNavigation) {
                          cancelAddressing();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AdvancedScreen.route, (route) => false);
                        } else {
                          machineLayoutDialog(context);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),
                !machine['brachiaria']
                    ? const SizedBox()
                    : Column(
                        children: [
                          const Text(
                            "Braquiária",
                            style: TextStyle(
                                fontSize: 22,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 2),
                            child: SizedBox(
                              height: 135,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: brachiaria["layout"].length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding / 4),
                                    child: JMCard(
                                        height: 200,
                                        width: 150,
                                        body: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical:
                                                          kDefaultPadding / 4),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Motor ${index + 1}",
                                                        style: const TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                brachiaria['addressed']
                                                            [index] ==
                                                        1
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        size: 38,
                                                        color: kSuccessColor,
                                                      )
                                                    : brachiaria['addressed']
                                                                [index] ==
                                                            0
                                                        ? const Icon(
                                                            Icons.cancel,
                                                            size: 38,
                                                            color: kErrorColor,
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        kDefaultPadding /
                                                                            4),
                                                            child:
                                                                LoadingAnimationWidget
                                                                    .beat(
                                                              color:
                                                                  Colors.blue,
                                                              size: 32,
                                                            ),
                                                          ),
                                                JMButton(
                                                    disabled:
                                                        brachiaria['addressed']
                                                                    [index] ==
                                                                1
                                                            ? true
                                                            : false,
                                                    text:
                                                        brachiaria['addressed']
                                                                    [index] !=
                                                                -1
                                                            ? "Endereçar"
                                                            : "Cancelar",
                                                    onPressed: () {
                                                      if (!isAddressing) {
                                                        bool noMotorAddressing = brachiaria[
                                                                    'addressed']
                                                                .every((item) =>
                                                                    item !=
                                                                    -1) ||
                                                            fertilizer[
                                                                    'addressed']
                                                                .every((item) =>
                                                                    item !=
                                                                    -1) ||
                                                            seed['addressed']
                                                                .every((item) =>
                                                                    item != -1);
                                                        if (brachiaria['addressed']
                                                                    [index] !=
                                                                -1 &&
                                                            noMotorAddressing) {
                                                          int numberMotor = 0;
                                                          brachiaria[
                                                                  'addressedLayout']
                                                              .forEach((k, v) {
                                                            if (v ==
                                                                index + 1) {
                                                              numberMotor =
                                                                  int.parse(k);
                                                            }
                                                          });

                                                          Messages().message[
                                                                  "motorAddressing"]!(
                                                              numberMotor);
                                                          setState(() {
                                                            brachiaria[
                                                                    'addressed']
                                                                [index] = -1;
                                                          });
                                                          isAddressing = true;
                                                        } else {
                                                          cancelAddressing();
                                                        }
                                                      } else {
                                                        cancelAddressing();
                                                      }
                                                    }),
                                                const SizedBox(
                                                    height:
                                                        kDefaultPadding / 4),
                                              ],
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                !machine['fertilizer']
                    ? const SizedBox()
                    : Column(
                        children: [
                          const SizedBox(height: kDefaultPadding / 2),
                          const Text(
                            "Adubo",
                            style: TextStyle(
                                fontSize: 22,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 2),
                            child: SizedBox(
                              height: 135,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: fertilizer["layout"].length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding / 4),
                                    child: JMCard(
                                        height: 200,
                                        width: 150,
                                        body: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical:
                                                          kDefaultPadding / 4),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Motor ${index + 1}",
                                                        style: const TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                // Icon(Icons.check_circle),
                                                fertilizer['addressed']
                                                            [index] ==
                                                        1
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        size: 38,
                                                        color: kSuccessColor,
                                                      )
                                                    : fertilizer['addressed']
                                                                [index] ==
                                                            0
                                                        ? const Icon(
                                                            Icons.cancel,
                                                            size: 38,
                                                            color: kErrorColor,
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        kDefaultPadding /
                                                                            4),
                                                            child:
                                                                LoadingAnimationWidget
                                                                    .beat(
                                                              color:
                                                                  Colors.blue,
                                                              size: 32,
                                                            ),
                                                          ),

                                                JMButton(
                                                    disabled:
                                                        fertilizer['addressed']
                                                                    [index] ==
                                                                1
                                                            ? true
                                                            : false,
                                                    text:
                                                        fertilizer['addressed']
                                                                    [index] !=
                                                                -1
                                                            ? "Endereçar"
                                                            : "Cancelar",
                                                    onPressed: () {
                                                      bool
                                                          noMotorAddressing =
                                                          brachiaria[
                                                                      'addressed']
                                                                  .every(
                                                                      (item) =>
                                                                          item !=
                                                                          -1) ||
                                                              fertilizer[
                                                                      'addressed']
                                                                  .every(
                                                                      (item) =>
                                                                          item !=
                                                                          -1) ||
                                                              seed['addressed']
                                                                  .every(
                                                                      (item) =>
                                                                          item !=
                                                                          -1);
                                                      if (fertilizer['addressed']
                                                                  [index] !=
                                                              -1 &&
                                                          noMotorAddressing) {
                                                        int numberMotor = 0;
                                                        fertilizer[
                                                                'addressedLayout']
                                                            .forEach((k, v) {
                                                          if (v == index + 1) {
                                                            numberMotor =
                                                                int.parse(k);
                                                          }
                                                        });

                                                        Messages().message[
                                                                "motorAddressing"]!(
                                                            numberMotor);
                                                        setState(() {
                                                          fertilizer[
                                                                  'addressed']
                                                              [index] = -1;
                                                        });
                                                        isAddressing = true;
                                                      } else {
                                                        cancelAddressing();
                                                      }
                                                    }),
                                                const SizedBox(
                                                    height:
                                                        kDefaultPadding / 4),
                                              ],
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: kDefaultPadding / 2),
                Column(
                  children: [
                    const Text(
                      "Semente",
                      style: TextStyle(
                          fontSize: 22,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 2),
                      child: SizedBox(
                        height: 135,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: machine['numberOfLines'],
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding / 4),
                              child: JMCard(
                                  height: 200,
                                  width: 150,
                                  body: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: kDefaultPadding / 4),
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Motor ${index + 1}",
                                                  style: const TextStyle(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          // Icon(Icons.check_circle),
                                          seed['addressed'][index] == 1
                                              ? const Icon(
                                                  Icons.check_circle,
                                                  size: 39,
                                                  color: kSuccessColor,
                                                )
                                              : seed['addressed'][index] == 0
                                                  ? const Icon(
                                                      Icons.cancel,
                                                      size: 39,
                                                      color: kErrorColor,
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                              .only(
                                                          bottom:
                                                              kDefaultPadding /
                                                                  4),
                                                      child:
                                                          LoadingAnimationWidget
                                                              .beat(
                                                        color: Colors.blue,
                                                        size: 32,
                                                      ),
                                                    ),

                                          JMButton(
                                              disabled:
                                                  seed['addressed'][index] == 1
                                                      ? true
                                                      : false,
                                              text:
                                                  seed['addressed'][index] != -1
                                                      ? "Endereçar"
                                                      : "Cancelar",
                                              onPressed: () {
                                                bool noMotorAddressing =
                                                    brachiaria['addressed']
                                                            .every((item) =>
                                                                item != -1) ||
                                                        fertilizer['addressed']
                                                            .every((item) =>
                                                                item != -1) ||
                                                        seed['addressed'].every(
                                                            (item) =>
                                                                item != -1);
                                                if (seed['addressed'][index] !=
                                                        -1 &&
                                                    noMotorAddressing) {
                                                  int numberMotor = 0;
                                                  seed['addressedLayout']
                                                      .forEach((k, v) {
                                                    if (v == index + 1) {
                                                      numberMotor =
                                                          int.parse(k);
                                                    }
                                                  });

                                                  Messages().message[
                                                          "motorAddressing"]!(
                                                      numberMotor);
                                                  setState(() {
                                                    seed['addressed'][index] =
                                                        -1;
                                                  });
                                                  isAddressing = true;
                                                } else {
                                                  cancelAddressing();
                                                }
                                              }),
                                          const SizedBox(
                                              height: kDefaultPadding / 4),
                                        ],
                                      ),
                                    ],
                                  )),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
