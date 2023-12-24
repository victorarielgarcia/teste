import 'dart:io';

import 'package:easytech_electric_blue/screens/sections_layout_screen.dart';
import 'package:easytech_electric_blue/screens/seed_screen.dart';
import 'package:easytech_electric_blue/screens/velocity_screen.dart';
import 'package:easytech_electric_blue/services/fill_disk_timer.dart';
import 'package:easytech_electric_blue/widgets/charts/seed_chart.dart';
import 'package:easytech_electric_blue/widgets/charts/seed_chart_demo.dart';
import 'package:easytech_electric_blue/widgets/speedometer_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/card.dart';
import '../widgets/charts/brachiaria_chart.dart';
import '../widgets/charts/fertilizer_chart.dart';
import '../widgets/charts/quality_chart.dart';
import '../widgets/dialogs/set_motors_dialog.dart';
import '../widgets/section_cut.dart';
import '../widgets/simple_card.dart';
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

class _WorkScreenState extends State<WorkScreen> with TickerProviderStateMixin {
  int countDiskFill = 0;
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 0);
    }

    _controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    // Timer.periodic(const Duration(milliseconds: 500), (timer) async {
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
    // Adiciona um listener para o status da animação
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        machine['diskFilling'] = false;
        // _controller.stop();
        // _controller.value = 0;
        _controller.reset(); // Opcionalmente, você pode reiniciar a animação
      }
    });

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
                            width: !Platform.isWindows ? 660 : 910,
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
                            width: !Platform.isWindows ? 660 : 910,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(180),
                                      //   child: SizedBox(
                                      //     width: 55,
                                      //     height: 55,
                                      //     child: JMButton(
                                      //         backgroundColor:
                                      //             machine['stoppedMotors']
                                      //                 ? kSecondaryColor
                                      //                 : kErrorColor,
                                      //         foregroundColor:
                                      //             machine['stoppedMotors']
                                      //                 ? kPrimaryColor
                                      //                 : kSecondaryColor,
                                      //                 icon: const Icon(Icons.block),
                                      //         text: machine['stoppedMotors']
                                      //             ? ""
                                      //             : "",
                                      //         onPressed: () {
                                      //           setState(() {
                                      //             if (machine['stoppedMotors']) {
                                      //               machine['stoppedMotors'] =
                                      //                   false;
                                      //               Messages().message[
                                      //                   "startMotors"]!();
                                      //             } else {
                                      //               machine['stoppedMotors'] =
                                      //                   true;
                                      //               Messages()
                                      //                   .message["stopMotors"]!();
                                      //             }
                                      //           });
                                      //         }),
                                      //   ),
                                      // ),

                                      GestureDetector(
                                        onTap: () {
                                          if (machine['diskFilling']) {
                                            setState(() {
                                              machine['diskFilling'] = false;
                                            });
                                            Messages().message["fillDisk"]!(0);
                                            FillDiskTimer().stopTimer();
                                            _controller.stop();
                                            _controller.value = 0;
                                          } else {
                                            setState(() {
                                              machine['diskFilling'] = true;
                                            });
                                            Messages().message["fillDisk"]!(1);
                                            _controller.forward();
                                            FillDiskTimer().startTimer();
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: 65,
                                              width: 65,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  height: 35,
                                                  width: 35,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: kSuccessColor,
                                                    value: animation.value,
                                                    strokeWidth: 10,
                                                    strokeCap: StrokeCap.round,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(55),
                                                child: SizedBox(
                                                  height: 65,
                                                  width: 65,
                                                  child: Transform.rotate(
                                                    angle: animation.value *
                                                        2 *
                                                        3.14159265,
                                                    child: SvgPicture.asset(
                                                      'assets/icons/disk.svg',
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                              Color(0xFF393737),
                                                              BlendMode.srcIn),
                                                    ),
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 65,
                                              width: 65,
                                              child: CircularProgressIndicator(
                                                color: kSuccessColor,
                                                value: animation.value,
                                                strokeAlign: 0.5,
                                                strokeWidth: 5,
                                                backgroundColor: kStrokeColor
                                                    .withOpacity(0.4),
                                                strokeCap: StrokeCap.round,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        VelocityScreen.route, (route) => false);
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.all(kDefaultPadding / 2),
                                    child: SpeedometerV2(),
                                  ),
                                ),
                                // const Padding(
                                //   padding: EdgeInsets.all(kDefaultPadding / 2),
                                //   child: Speedometer(),
                                // ),
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
                                      fontSize: 16),
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
                              text: '0',
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
                    setMotorsDialog();
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
                                ? 205 + (!Platform.isWindows ? 0 : 50)
                                : 160 + (!Platform.isWindows ? 0 : 50),
                        width: double.infinity,
                        body: Padding(
                          padding:
                              const EdgeInsets.only(top: kDefaultPadding / 2),
                          child: !systemSimulationMode
                              ? const SeedChart()
                              : const SeedChartDemo(),
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
