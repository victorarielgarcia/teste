
import 'package:flutter/material.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../widgets/back_button.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';
import '../widgets/dialogs/machine_layout_dialog.dart';
import '../widgets/simple_card.dart';
import '../widgets/top_bar.dart';
import 'machine_screen.dart';

class SectionsLayoutScreen extends StatefulWidget {
  const SectionsLayoutScreen({super.key});
  static const String route = '/machine/sections/layout';

  @override
  State<SectionsLayoutScreen> createState() => _SectionsLayoutScreenState();
}

class _SectionsLayoutScreenState extends State<SectionsLayoutScreen> {
  bool disableNavigation = false;
 
  void checkLayout() {
    int total = 0;
    for (int section in machine['sectionsLayout']) {
      total += section;
    }
    if (total < machine["numberOfLines"] && total > 0) {
      setState(() {
        disableNavigation = true;
      });
    } else {
      setState(() {
        disableNavigation = false;
      });
    }
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
            onExit: () {
              for (var i = 0;
                  i < ((List<bool>.from(section['cutted'])).length - 1);
                  i++) {
                (section['cutted'] as List<dynamic>)[i] = false;
              }
            },
          ),
          disableNavigation
              ? GestureDetector(
                  onTap: () {
                    machineLayoutDialog();
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
                          "Configurações de Seções",
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
                          machineLayoutDialog();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),
                SimpleCard(
                    title: 'Número de Linhas',
                    text: machine["numberOfLines"].toString()),
                const SizedBox(height: kDefaultPadding),
                Column(
                  children: [
                    const Text(
                      "Seções",
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
                          itemCount: machine["sectionsLayout"].length + 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding / 4),
                                child:
                                    (machine["sectionsLayout"].length) == index
                                        ? InkWell(
                                            onTap: () {
                                              soundManager.playSound('click');
                                              if (fertilizer['layout'].length >
                                                  machine["sectionIndex"]) {
                                                setState(() {
                                                  machine["sectionsLayout"].add(
                                                      fertilizer['layout'][
                                                          machine[
                                                              "sectionIndex"]]);
                                                });
                                                machine["sectionIndex"]++;
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
                                                            "Seção ${index + 1}",
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
                                                              machine["sectionsLayout"]
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
                                                                            while (true) {
                                                                              machine["sectionIndex"]--;
                                                                              setState(() {
                                                                                machine["sectionsLayout"][index] -= fertilizer['layout'][machine["sectionIndex"]];
                                                                              });
                                                                              if (machine["sectionsLayout"][index] == 0) {
                                                                                setState(() {
                                                                                  machine["sectionsLayout"].removeLast();
                                                                                });
                                                                                break;
                                                                              }
                                                                            }
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
                                                      machine["sectionsLayout"]
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
                                                        disabled: index <
                                                                machine['sectionsLayout']
                                                                        .length -
                                                                    1
                                                            ? true
                                                            : false,
                                                        onPressed: () {
                                                          if (machine["sectionsLayout"]
                                                                  [index] >
                                                              0) {
                                                            machine[
                                                                "sectionIndex"]--;
                                                            setState(() {
                                                              machine["sectionsLayout"]
                                                                      [index] -=
                                                                  fertilizer[
                                                                          'layout']
                                                                      [machine[
                                                                          "sectionIndex"]];
                                                            });
                                                            if (machine["sectionsLayout"]
                                                                    [index] ==
                                                                0) {
                                                              setState(() {
                                                                machine["sectionsLayout"]
                                                                    .removeLast();
                                                              });
                                                            }
                                                            checkLayout();
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
                                                      height: 45,
                                                      child: JMButton(
                                                        disabled: index <
                                                                machine['sectionsLayout']
                                                                        .length -
                                                                    1
                                                            ? true
                                                            : false,
                                                        text: '+',
                                                        onPressed: () {
                                                          if (fertilizer[
                                                                      'layout']
                                                                  .length >
                                                              machine[
                                                                  "sectionIndex"]) {
                                                            setState(() {
                                                              machine["sectionsLayout"]
                                                                      [index] +=
                                                                  fertilizer[
                                                                          'layout']
                                                                      [machine[
                                                                          "sectionIndex"]];
                                                            });
                                                            machine[
                                                                "sectionIndex"]++;
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
//   final bool ismachine;
//   final int index;

//   const SessionCard({
//     super.key,
//     required this.index,
//     this.isBrachiaria = false,
//     this.ismachine = false,
//   });

//   @override
//   State<SessionCard> createState() => _SessionCardState();
// }

// class _SessionCardState extends State<SessionCard> {
//   List<int> brachiaria["layout"] = brachiaria["layout"];
//   List<int> machine["sectionsLayout"] = machine["sectionsLayout"];
//   final machineState = machineManager.state;

//   @override
//   void initState() {
//     machineManager.addListener(() {
//       if (mounted) {
//         setState(() {
//           brachiaria["layout"] = machineManager.state.brachiaria["layout"];
//           machine["sectionsLayout"] = machineManager.state.machine["sectionsLayout"];
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
