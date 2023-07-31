import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
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

class ModuleAddressingScreen extends StatefulWidget {
  const ModuleAddressingScreen({super.key});
  static const String route = '/advanced/module/addressing';

  @override
  State<ModuleAddressingScreen> createState() => _ModuleAddressingScreenState();
}

class _ModuleAddressingScreenState extends State<ModuleAddressingScreen> {
  final moduleAddressingState = moduleAddressingManager.state;
  final moduleVerionState = moduleVersionManager.state;
  Timer? timer;
  bool disableNavigation = false;
  bool isAddressing = false;
  int lastState = -1;
  int moduleID = 0;
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
    disableNavigation = !checkMaxNumberOfLines(brachiaria["layout"]) ||
        !checkMaxNumberOfLines(fertilizer["layout"]);
    setState(() {});
  }

  void cancelAddressing() {
    if (moduleID != 0) {
      setState(() {
        module['addressed'][moduleID - 1] = lastState;
      });
      moduleID = 0;
      timerCount = 0;
      isAddressing = false;
    }
  }

  void moduleAddressingListener() {
    if (mounted) {
      setState(() {});
      cancelAddressing();
      timerCount = 0;
    }
  }

  void moduleVersionListener() {
    if (mounted) {
      setState(() {
        moduleVerionState.version;
      });
    }
  }

  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 21);
    }
    moduleAddressingManager.addListener(moduleAddressingListener);
    moduleVersionManager.addListener(moduleVersionListener);
    timer ??= Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (moduleID != 0) {
        isAddressing = true;
        AppLogger.log('TIMER ACTIVE $moduleID // $isAddressing');
        Messages().message["moduleAddressing"]!(moduleID);
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
    moduleAddressingManager.removeListener(moduleAddressingListener);
    moduleVersionManager.removeListener(moduleVersionListener);
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
                          "Endereçamento dos módulos",
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
                const SizedBox(height: kDefaultPadding * 3),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2),
                  child: SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: module["layout"].length + 1,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding / 4),
                          child: (module["layout"].length) == index
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      module["layout"].add(1);
                                      module["addressed"].add(0);
                                      // machineManager.update(
                                      //      module["layout"], fertilizerLayout);
                                    });
                                  },
                                  child: Container(
                                      height: 145,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.4),
                                          border: Border.all(
                                              color: kStrokeColor, width: 1),
                                          borderRadius: BorderRadius.circular(
                                              kDefaultBorderSize)),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: kDefaultPadding / 4),
                                          Text("+",
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 28)),
                                        ],
                                      )),
                                )
                              : JMCard(
                                  height: 300,
                                  width: 200,
                                  body: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: kDefaultPadding / 2),
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Módulo ${index + 1}",
                                                  style: const TextStyle(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            index != module["layout"].length - 1
                                                ? const SizedBox()
                                                : SizedBox(
                                                    width: double.infinity,
                                                    height: 30,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .only(
                                                              right:
                                                                  kDefaultPadding /
                                                                      2),
                                                          child: ClipOval(
                                                            child: Material(
                                                              color:
                                                                  kPrimaryColor,
                                                              child: InkWell(
                                                                splashColor:
                                                                    kSecondaryColor,
                                                                onTap: () {
                                                                  setState(() {
                                                                    module["layout"]
                                                                        .removeLast();
                                                                    module["addressed"]
                                                                        .removeLast();
                                                                    // machineManager.update(
                                                                    //      module["layout"], fertilizerLayout);
                                                                  });
                                                                },
                                                                child: const SizedBox(
                                                                    width: 30,
                                                                    height: 30,
                                                                    child: Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color:
                                                                            kSecondaryColor,
                                                                        size:
                                                                            18)),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          // Icon(Icons.check_circle),
                                          module['addressed'][index] == 1
                                              ? const Icon(
                                                  Icons.check_circle,
                                                  size: 38,
                                                  color: kSuccessColor,
                                                )
                                              : module['addressed'][index] == 0
                                                  ? const Icon(
                                                      Icons.cancel,
                                                      size: 38,
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

                                          const SizedBox(
                                              height: kDefaultPadding / 4),
                                          !(module['addressed'][index] == 1)
                                              ? const SizedBox()
                                              : Text(
                                                  'Versão: ${'${moduleVerionState.version[index].toString().padLeft(4, '0').substring(0, 1)}.${moduleVerionState.version[index].toString().padLeft(4, '0').substring(1, 2)}.${moduleVerionState.version[index].toString().padLeft(4, '0').substring(2, 4)}'}',
                                                  style: const TextStyle(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16),
                                                ),
                                          JMButton(
                                              disabled: module['addressed']
                                                          [index] ==
                                                      1
                                                  ? true
                                                  : false,
                                              text: module['addressed']
                                                          [index] !=
                                                      -1
                                                  ? "Endereçar"
                                                  : "Cancelar",
                                              onPressed: () {
                                                bool noModuleAddressing =
                                                    module['addressed'].every(
                                                        (item) => item != -1);
                                                if (module['addressed']
                                                            [index] !=
                                                        -1 &&
                                                    noModuleAddressing) {
                                                  moduleID = index + 1;
                                                  Messages().message[
                                                          "moduleAddressing"]!(
                                                      moduleID);
                                                  lastState =
                                                      module['addressed']
                                                          [index];
                                                  setState(() {
                                                    module['addressed'][index] =
                                                        -1;
                                                  });
                                                } else {
                                                  cancelAddressing();
                                                }
                                              }),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            module["layout"][index].toString(),
                                            style: const TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 24),
                                          ),
                                          const Text(
                                            " linhas",
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: kDefaultPadding / 4),
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 98,
                                              height: 50,
                                              child: JMButton(
                                                text: '-',
                                                onPressed: () {
                                                  if (module["layout"][index] >
                                                      0) {
                                                    setState(() {
                                                      module["layout"][index]--;
                                                    });
                                                  }
                                                },
                                                lessButton: true,
                                              ),
                                            ),
                                            Container(
                                                color: kSecondaryColor,
                                                height: 50,
                                                width: 1),
                                            SizedBox(
                                              width: 98,
                                              height: 50,
                                              child: JMButton(
                                                text: '+',
                                                onPressed: () {
                                                  if (module["layout"][index] <
                                                      12) {
                                                    setState(() {
                                                      module["layout"][index]++;
                                                      module["layout"][index]++;
                                                    });
                                                  }
                                                },
                                                moreButton: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
