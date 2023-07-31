import 'package:easytech_electric_blue/screens/machine_screen.dart';
import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/widgets/button.dart';
import 'package:easytech_electric_blue/widgets/card.dart';
import 'package:easytech_electric_blue/widgets/dialogs/machine_layout_dialog.dart';
import 'package:easytech_electric_blue/widgets/simple_card.dart';
import 'package:flutter/material.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../widgets/back_button.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/top_bar.dart';

class MachineLayoutScreen extends StatefulWidget {
  const MachineLayoutScreen({super.key});
  static const String route = '/machine/layout';

  @override
  State<MachineLayoutScreen> createState() => _MachineLayoutScreenState();
}

class _MachineLayoutScreenState extends State<MachineLayoutScreen> {
  bool disableNavigation = false;

  bool checkMaxNumberOfLines(section) {
    int count = 0;
    bool condition = false;
    for (int element in section) {
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
    machine['sectionsLayout'].clear();
    machine['sectionIndex'] = 0;
  }

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
      bottomNavigationBar: Stack(
        children: [
          JMBottomNavigationBar(
            onExit: () {},
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
                          "Configurações de Layout",
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
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              MachineScreen.route, (route) => false);
                        } else {
                          machineLayoutDialog(context);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),
                SimpleCard(
                    title: 'Número de Linhas',
                    text: machine["numberOfLines"].toString()),
                const SizedBox(height: kDefaultPadding / 2),
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
                              height: 145,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: brachiaria["layout"].length + 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding / 4),
                                    child: (brachiaria["layout"].length) ==
                                            index
                                        ? InkWell(
                                            onTap: () {
                                              soundManager.playSound('click');
                                              if (!checkMaxNumberOfLines(
                                                  brachiaria["layout"])) {
                                                setState(() {
                                                  brachiaria["layout"].add(1);
                                                });
                                              }
                                              checkLayout();
                                            },
                                            child: Container(
                                                height: 145,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.4),
                                                    border: Border.all(
                                                        color: kStrokeColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            kDefaultBorderSize)),
                                                child: const Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Adicionar",
                                                      style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            kDefaultPadding /
                                                                4),
                                                    Text("+",
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontSize: 28)),
                                                  ],
                                                )),
                                          )
                                        : JMCard(
                                            height: 145,
                                            width: 200,
                                            body: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical:
                                                          kDefaultPadding / 2),
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
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                      index !=
                                                              brachiaria["layout"]
                                                                      .length -
                                                                  1
                                                          ? const SizedBox()
                                                          : SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 30,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right: kDefaultPadding /
                                                                            2),
                                                                    child:
                                                                        ClipOval(
                                                                      child:
                                                                          Material(
                                                                        color:
                                                                            kPrimaryColor, // Button color
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              kSecondaryColor, // Splash color
                                                                          onTap:
                                                                              () {
                                                                            soundManager.playSound('click');
                                                                            setState(() {
                                                                              brachiaria["layout"].removeLast();
                                                                            });
                                                                            checkLayout();
                                                                          },
                                                                          child: const SizedBox(
                                                                              width: 30,
                                                                              height: 30,
                                                                              child: Icon(Icons.delete, color: kSecondaryColor, size: 18)),
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      brachiaria["layout"]
                                                              [index]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: kPrimaryColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 24),
                                                    ),
                                                    const Text(
                                                      " linhas",
                                                      style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                      width: 98,
                                                      height: 45,
                                                      child: JMButton(
                                                        text: '-',
                                                        onPressed: () {
                                                          if (brachiaria[
                                                                      "layout"]
                                                                  [index] !=
                                                              1) {
                                                            setState(() {
                                                              brachiaria[
                                                                      "layout"]
                                                                  [index]--;
                                                            });
                                                          }
                                                          checkLayout();
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
                                                      height: 45,
                                                      child: JMButton(
                                                        text: '+',
                                                        onPressed: () {
                                                          if (brachiaria[
                                                                      "layout"]
                                                                  [index] <
                                                              20) {
                                                            if (!checkMaxNumberOfLines(
                                                                brachiaria[
                                                                    "layout"])) {
                                                              setState(() {
                                                                brachiaria[
                                                                        "layout"]
                                                                    [index]++;
                                                              });
                                                            }
                                                          }
                                                          checkLayout();
                                                        },
                                                        moreButton: true,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                        ],
                      ),
                !machine['fertilizer']
                    ? const SizedBox()
                    : Column(
                        children: [
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
                              height: 145,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: fertilizer["layout"].length + 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding / 4),
                                      child: (fertilizer["layout"].length) ==
                                              index
                                          ? InkWell(
                                              onTap: () {
                                                soundManager.playSound('click');
                                                if (!checkMaxNumberOfLines(
                                                    fertilizer["layout"])) {
                                                  setState(() {
                                                    fertilizer["layout"].add(1);
                                                  });
                                                }
                                                checkLayout();
                                              },
                                              child: Container(
                                                  height: 145,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      border: Border.all(
                                                          color: kStrokeColor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              kDefaultBorderSize)),
                                                  child: const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Adicionar",
                                                        style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              kDefaultPadding /
                                                                  4),
                                                      Text("+",
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 28)),
                                                    ],
                                                  )),
                                            )
                                          : JMCard(
                                              height: 145,
                                              width: 200,
                                              body: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical:
                                                            kDefaultPadding /
                                                                2),
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
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                        index !=
                                                                fertilizer["layout"]
                                                                        .length -
                                                                    1
                                                            ? const SizedBox()
                                                            : SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                height: 30,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              kDefaultPadding / 2),
                                                                      child:
                                                                          ClipOval(
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              kPrimaryColor, // Button color
                                                                          child:
                                                                              InkWell(
                                                                            splashColor:
                                                                                kSecondaryColor, // Splash color
                                                                            onTap:
                                                                                () {
                                                                              soundManager.playSound('click');
                                                                              setState(() {
                                                                                fertilizer["layout"].removeLast();
                                                                              });
                                                                              checkLayout();
                                                                            },
                                                                            child: const SizedBox(
                                                                                width: 30,
                                                                                height: 30,
                                                                                child: Icon(Icons.delete, color: kSecondaryColor, size: 18)),
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
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        fertilizer["layout"]
                                                                [index]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 24),
                                                      ),
                                                      const Text(
                                                        " linhas",
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      SizedBox(
                                                        width: 98,
                                                        height: 45,
                                                        child: JMButton(
                                                          text: '-',
                                                          onPressed: () {
                                                            if (fertilizer[
                                                                        "layout"]
                                                                    [index] !=
                                                                1) {
                                                              setState(() {
                                                                fertilizer[
                                                                        "layout"]
                                                                    [index]--;
                                                              });
                                                            }
                                                            checkLayout();
                                                          },
                                                          lessButton: true,
                                                        ),
                                                      ),
                                                      Container(
                                                          color:
                                                              kSecondaryColor,
                                                          height: 50,
                                                          width: 1),
                                                      SizedBox(
                                                        width: 98,
                                                        height: 45,
                                                        child: JMButton(
                                                          text: '+',
                                                          onPressed: () {
                                                            if (fertilizer[
                                                                        "layout"]
                                                                    [index] <
                                                                3) {
                                                              if (!checkMaxNumberOfLines(
                                                                  fertilizer[
                                                                      "layout"])) {
                                                                setState(() {
                                                                  fertilizer[
                                                                          "layout"]
                                                                      [index]++;
                                                                });
                                                              }
                                                            }
                                                            checkLayout();
                                                          },
                                                          moreButton: true,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )));
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

// class SessionCard extends StatefulWidget {
//   final bool isBrachiaria;
//   final bool isFertilizer;
//   final int index;

//   const SessionCard({
//     super.key,
//     required this.index,
//     this.isBrachiaria = false,
//     this.isFertilizer = false,
//   });

//   @override
//   State<SessionCard> createState() => _SessionCardState();
// }

// class _SessionCardState extends State<SessionCard> {
//   List<int> brachiaria["layout"] = brachiaria["layout"];
//   List<int> fertilizer["layout"] = fertilizer["layout"];
//   final machineState = machineManager.state;

//   @override
//   void initState() {
//     machineManager.addListener(() {
//       if (mounted) {
//         setState(() {
//           brachiaria["layout"] = machineManager.state.brachiaria["layout"];
//           fertilizer["layout"] = machineManager.state.fertilizer["layout"];
//         });
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
