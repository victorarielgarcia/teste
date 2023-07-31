
import 'package:easytech_electric_blue/screens/sections_layout_screen.dart';
import 'package:easytech_electric_blue/screens/seed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';
import '../widgets/charts/brachiaria_chart.dart';
import '../widgets/charts/fertilizer_chart.dart';
import '../widgets/charts/quality_chart.dart';
import '../widgets/charts/seed_chart.dart';
import '../widgets/dialogs/set_motors_dialog.dart';
import '../widgets/section_cut.dart';
import '../widgets/simple_card.dart';
import '../widgets/speedometer.dart';
import '../widgets/top_bar.dart';
import '../widgets/work_view.dart';
import 'brachiaria_screen.dart';
import 'fertilizer_screen.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});
  static const String route = '/work';

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: JMBottomNavigationBar(
        onExit: () {},
      ),
      appBar:
          const PreferredSize(preferredSize: Size(800, 70), child: TopBar()),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                kDefaultPadding, kDefaultPadding, kDefaultPadding, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  SeedScreen.route, (route) => false),
                          child: SimpleCard(
                            title: 'Taxa de semente',
                            text: '${seed['desiredRate']}',
                            textFontSize: 30,
                            unit: 'sem/m',
                            height:
                                (machine['brachiaria'] && machine['fertilizer'])
                                    ? 100
                                    : 115,
                            width: 280,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  FertilizerScreen.route, (route) => false),
                          child: SimpleCard(
                            title: 'Taxa de adubo',
                            text: '${fertilizer['desiredRate']}',
                            textFontSize: 30,
                            unit: 'kg/ha',
                            height:
                                (machine['brachiaria'] && machine['fertilizer'])
                                    ? 100
                                    : 115,
                            width: 280,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  BrachiariaScreen.route, (route) => false),
                          child: SimpleCard(
                            title: 'Taxa de braquiária',
                            text: '${brachiaria['desiredRate']}',
                            textFontSize: 30,
                            unit: 'sem/m',
                            height:
                                (machine['brachiaria'] && machine['fertilizer'])
                                    ? 100
                                    : 115,
                            width: 280,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: kDefaultPadding / 2),
                    Padding(
                      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          JMCard(
                            width: 660,
                            height:
                                (machine['brachiaria'] && machine['fertilizer'])
                                    ? 320
                                    : 365,
                            body: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kDefaultBorderSize),

                              child: const JMWorkView(),
                              // child: Container(
                              //   color: kBackgroundColor,
                              // ),
                              // child: Image.asset(
                              //   'assets/images/work_beta.png',
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                          ),
                          SizedBox(
                            width: 660,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding / 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: JMButton(
                                            backgroundColor:
                                                machine['stoppedMotors']
                                                    ? kSecondaryColor
                                                    : kErrorColor,
                                            foregroundColor:
                                                machine['stoppedMotors']
                                                    ? kPrimaryColor
                                                    : kSecondaryColor,
                                            text: machine['stoppedMotors']
                                                ? "Iniciar motores"
                                                : "Parar motores",
                                            onPressed: () {
                                              setState(() {
                                                if (machine['stoppedMotors']) {
                                                  machine['stoppedMotors'] =
                                                      false;
                                                  Messages().message[
                                                      "startMotors"]!();
                                                } else {
                                                  machine['stoppedMotors'] =
                                                      true;
                                                  Messages()
                                                      .message["stopMotors"]!();
                                                }
                                              });
                                            }),
                                      ),
                                      const SizedBox(
                                          width: kDefaultPadding / 2),
                                      SizedBox(
                                        height: 50,
                                        child: JMButton(
                                            backgroundColor:
                                                machine['diskFilling']
                                                    ? kSuccessColor
                                                    : kSecondaryColor,
                                            foregroundColor:
                                                machine['diskFilling']
                                                    ? kSecondaryColor
                                                    : kPrimaryColor,
                                            text: machine['diskFilling']
                                                ? "Enchendo..."
                                                : "Encher disco",
                                            onPressed: () {
                                              if (machine['diskFilling']) {
                                                setState(() {
                                                  machine['diskFilling'] =
                                                      false;
                                                });
                                                Messages()
                                                    .message["fillDisk"]!(0);
                                              } else {
                                                setState(() {
                                                  machine['diskFilling'] = true;
                                                });
                                                Messages()
                                                    .message["fillDisk"]!(1);
                                              }
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: kDefaultPadding / 2,
                                      horizontal: kDefaultPadding / 2),
                                  child: Speedometer(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding / 2),
                    Column(
                      children: [
                        const SizedBox(height: kDefaultPadding / 2),
                        JMCard(
                          height:
                              (machine['brachiaria'] && machine['fertilizer'])
                                  ? 210
                                  : 240,
                          width: 280,
                          body: const Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: kDefaultPadding / 2),
                                child: Text(
                                  "Qualidade",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: kDefaultPadding / 2),
                                child: QualityChart(),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SimpleCard(
                              title: 'Área parcial',
                              titleFontSize: 16,
                              text: '1020',
                              textFontSize: 28,
                              unit: 'ha',
                              unitFontSize: 16,
                              height: (machine['brachiaria'] &&
                                      machine['fertilizer'])
                                  ? 100
                                  : 115,
                              width: 280,
                            ),
                            // SizedBox(width: kDefaultPadding / 2),
                            // SimpleCard(
                            //   title: 'C.V.',
                            //   titleFontSize: 16,
                            //   text: '5',
                            //   textFontSize: 28,
                            //   unit: '%',
                            //   unitFontSize: 16,
                            //   height: 115,
                            //   width: 135,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding / 4),
                GestureDetector(
                  onDoubleTap: () {
                    setMotorsDialog(context);
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: kDefaultPadding / 4),

                      !machine['brachiaria']
                          ? const SizedBox()
                          : Column(
                              children: [
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    const JMCard(
                                      height: 35,
                                      width: double.infinity,
                                      body: BrachiariaChart(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      child: SizedBox(
                                        height: 20,
                                        child: SvgPicture.asset(
                                          "assets/icons/brachiaria.svg",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: kDefaultPadding / 2),
                              ],
                            ),
                      !machine['fertilizer']
                          ? const SizedBox()
                          : Column(
                              children: [
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    const JMCard(
                                      height: 35,
                                      width: double.infinity,
                                      body: FertilizerChart(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      child: SizedBox(
                                          height: 20,
                                          child: SvgPicture.asset(
                                            "assets/icons/fertilizer.svg",
                                          )),
                                    )
                                  ],
                                ),
                                const SizedBox(height: kDefaultPadding / 2),
                              ],
                            ),

                      JMCard(
                        height:
                            (!machine['brachiaria'] && !machine['fertilizer'])
                                ? 205
                                : 160,
                        width: double.infinity,
                        body: const Padding(
                          padding: EdgeInsets.only(top: kDefaultPadding / 2),
                          child: SeedChart(),
                        ),
                      ),
                      // const SizedBox(height: kDefaultPadding / 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding,
                      vertical: kDefaultPadding / 2),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamedAndRemoveUntil(context,
                          SectionsLayoutScreen.route, (route) => false);
                    },
                    child: Container(
                      height: 30,
                      width: 60,
                      decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(kDefaultBorderSize)),
                          border: Border.all(color: kStrokeColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          'assets/icons/cut_section.svg',
                          colorFilter: ColorFilter.mode(
                            kPrimaryColor.withOpacity(0.8),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ))),
          // Positioned(
          //     top: 605,
          //     child: Container(
          //       width: 1500,
          //       height: 15,
          //       color: Colors.red,
          //     )),
          // Positioned(
          //     top: 550,
          //     child: Container(
          //       width: 19,
          //       height: 100,
          //       color: Colors.red,
          //     )),
          // Positioned(
          //     top: 30,
          //     child: Container(
          //       width: 1500,
          //       height: 318,
          //       color: Colors.red,
          //     )),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 40),
              child: SectionCut(),
            ),
          )
        ],
      ),
    );
  }
}