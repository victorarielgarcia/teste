import 'package:android_intent_plus/android_intent.dart';
import 'package:easytech_electric_blue/screens/module_addressing_screen.dart';
import 'package:easytech_electric_blue/screens/motor_addressing_screen.dart';
import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/bluetooth.dart';
import '../services/logger.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';
import '../widgets/top_bar.dart';

class AdvancedScreen extends StatefulWidget {
  const AdvancedScreen({super.key});
  static const String route = '/advanced';

  @override
  State<AdvancedScreen> createState() => _AdvancedScreenState();
}

class _AdvancedScreenState extends State<AdvancedScreen> {
  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 20);
    }
    _init();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   advancedDialog(context);
    // });
    super.initState();
  }

  bool isLoadingDevices = false;
  _init() async {
    setState(() {
      isLoadingDevices = true;
    });
    await Bluetooth().getPairedDevices();
    setState(() {
      isLoadingDevices = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: JMBottomNavigationBar(
        onExit: () async {
          await Messages().message["advanced"]!();
          AppLogger.log("SEND CONFIGURATIONS: $advancedSettings");
        },
      ),
      appBar:
          const PreferredSize(preferredSize: Size(800, 70), child: TopBar()),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 2, vertical: kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Configurações Avançadas",
                style: TextStyle(
                    fontSize: 22,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: kDefaultPadding),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Row(
              //       children: [
              //         Padding(
              //           padding:
              //               const EdgeInsets.only(top: kDefaultPadding / 2),
              //           child: Container(
              //             width: 320,
              //             height: 200,
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               border: Border.all(color: kStrokeColor),
              //               borderRadius:
              //                   BorderRadius.circular(kDefaultBorderSize),
              //             ),
              //             child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   const Padding(
              //                     padding: EdgeInsets.symmetric(
              //                         vertical: kDefaultPadding / 2),
              //                     child: Text(
              //                       'Semente',
              //                       style: TextStyle(
              //                           color: kPrimaryColor,
              //                           fontWeight: FontWeight.w300,
              //                           fontSize: 18),
              //                     ),
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.only(
              //                         top: kDefaultPadding / 4),
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: const [
              //                         ToogleButton(
              //                           id: 1,
              //                           firstText: '50',
              //                           secoundText: '100',
              //                         ),
              //                         SizedBox(height: kDefaultPadding / 2),
              //                         ToogleButton(
              //                           id: 2,
              //                           icon: true,
              //                           rotate: true,
              //                           firstIcon: Icons.refresh,
              //                           secoundIcon: Icons.refresh,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ]),
              //           ),
              //         ),
              //         const SizedBox(width: kDefaultPadding / 2),
              //         Padding(
              //           padding:
              //               const EdgeInsets.only(top: kDefaultPadding / 2),
              //           child: Container(
              //             width: 320,
              //             height: 200,
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               border: Border.all(color: kStrokeColor),
              //               borderRadius:
              //                   BorderRadius.circular(kDefaultBorderSize),
              //             ),
              //             child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   const Padding(
              //                     padding: EdgeInsets.symmetric(
              //                         vertical: kDefaultPadding / 2),
              //                     child: Text(
              //                       'Adubo',
              //                       style: TextStyle(
              //                           color: kPrimaryColor,
              //                           fontWeight: FontWeight.w300,
              //                           fontSize: 18),
              //                     ),
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.only(
              //                         top: kDefaultPadding / 4),
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: const [
              //                         ToogleButton(
              //                           id: 3,
              //                           firstText: '50',
              //                           secoundText: '100',
              //                         ),
              //                         SizedBox(height: kDefaultPadding / 2),
              //                         ToogleButton(
              //                           id: 4,
              //                           icon: true,
              //                           rotate: true,
              //                           firstIcon: Icons.refresh,
              //                           secoundIcon: Icons.refresh,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ]),
              //           ),
              //         ),
              //         const SizedBox(width: kDefaultPadding / 2),
              //         Padding(
              //           padding:
              //               const EdgeInsets.only(top: kDefaultPadding / 2),
              //           child: Container(
              //             width: 320,
              //             height: 200,
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               border: Border.all(color: kStrokeColor),
              //               borderRadius:
              //                   BorderRadius.circular(kDefaultBorderSize),
              //             ),
              //             child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   const Padding(
              //                     padding: EdgeInsets.symmetric(
              //                         vertical: kDefaultPadding / 2),
              //                     child: Text(
              //                       'Braquiária',
              //                       style: TextStyle(
              //                           color: kPrimaryColor,
              //                           fontWeight: FontWeight.w300,
              //                           fontSize: 18),
              //                     ),
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.only(
              //                         top: kDefaultPadding / 4),
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: const [
              //                         ToogleButton(
              //                           id: 5,
              //                           firstText: '50',
              //                           secoundText: '100',
              //                         ),
              //                         SizedBox(height: kDefaultPadding / 2),
              //                         ToogleButton(
              //                           id: 6,
              //                           icon: true,
              //                           rotate: true,
              //                           firstIcon: Icons.refresh,
              //                           secoundIcon: Icons.refresh,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ]),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),

              Column(
                children: [
                  Text(
                    "Versão: $softwareVersion",
                    style: const TextStyle(
                        fontSize: 16,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(height: kDefaultPadding * 2),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Bluetooth",
                        style: TextStyle(
                            fontSize: 22,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(width: kDefaultPadding),
                      JMButton(
                          text: '',
                          icon: const Icon(Icons.bluetooth),
                          onPressed: () {
                            const AndroidIntent(
                              action: 'android.settings.BLUETOOTH_SETTINGS',
                            ).launch();
                          }),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  isLoadingDevices
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              items: Bluetooth().getDeviceItems(),
                              onChanged: (value) =>
                                  setState(() => device = value!),
                              value: device,
                            ),
                            const SizedBox(width: kDefaultPadding),
                            JMButton(
                              text: "Conectar",
                              onPressed: () async {
                                bluetooth['address'] = device.address;
                              },
                            )
                          ],
                        ),
                  const SizedBox(height: kDefaultPadding / 2),
                ],
              ),
              const SizedBox(height: kDefaultPadding),
              Column(
                children: [
                  const Text(
                    "Endereçamentos",
                    style: TextStyle(
                        fontSize: 22,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w300),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: kDefaultPadding),
                          JMCard(
                            height: 170,
                            width: 160,
                            body: Padding(
                              padding: const EdgeInsets.fromLTRB(0,
                                  kDefaultPadding / 2, 0, kDefaultPadding / 4),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Módulos",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18),
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/module.svg',
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
                                            text: 'Endereçar',
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        ModuleAddressingScreen
                                                            .route,
                                                        (route) => false))),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: kDefaultPadding / 2),
                      Column(
                        children: [
                          const SizedBox(height: kDefaultPadding),
                          JMCard(
                            height: 170,
                            width: 160,
                            body: Padding(
                              padding: const EdgeInsets.fromLTRB(0,
                                  kDefaultPadding / 2, 0, kDefaultPadding / 4),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Motores",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18),
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/motor.svg',
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
                                            text: 'Endereçar',
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        MotorAddressingScreen
                                                            .route,
                                                        (route) => false))),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
