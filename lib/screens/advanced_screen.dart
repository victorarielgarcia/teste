import 'dart:async';
import 'dart:typed_data';
import 'package:easytech_electric_blue/screens/module_addressing_screen.dart';
import 'package:easytech_electric_blue/screens/motor_addressing_screen.dart';
import 'package:easytech_electric_blue/utilities/constants/sizes.dart';
import 'package:easytech_electric_blue/widgets/boolean_card.dart';
import 'package:easytech_electric_blue/widgets/config_card.dart';
import 'package:easytech_electric_blue/widgets/toogle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
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
  Timer? timer;
  List<DropdownMenuItem<DiscoveredDevice>>? dropdownItems;
  DiscoveredDevice? device;
  DiscoveredDevice? selectedDevice;
  bool changedSelection = false;
  final seedDropState = seedDropManager.state;
  void seedDropListener() {
    if (mounted) {
      setState(() {
        seedDropState;
      });
    }
  }

  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 20);
    }
    seedDropManager.addListener(seedDropListener);

    _init();
    super.initState();
  }

  @override
  void dispose() {
    seedDropManager.removeListener(seedDropListener);
    timer!.cancel();
    super.dispose();
  }

  SvgPicture getRssiIcon(int rssi) {
    if (rssi > -75) {
      return SvgPicture.asset('assets/icons/signal_3.svg'); // Alto
    } else if (rssi > -85 && rssi <= -75) {
      return SvgPicture.asset('assets/icons/signal_2.svg'); // Médio
    } else if (rssi >= -90 && rssi <= -85) {
      return SvgPicture.asset('assets/icons/signal_1.svg'); // Fraco
    } else {
      return SvgPicture.asset('assets/icons/signal_0.svg'); // Muito Fraco
    }
  }

  _getDevices() {
    setState(() {
      dropdownItems = devices.map((device) {
        return DropdownMenuItem<DiscoveredDevice>(
          value: device,
          child: Row(
            children: [
              Text("${device.name} : "),
              getRssiIcon(device.rssi),
              Text(
                " ${device.rssi}dBm",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      }).toList();
    });
    // Se selectedDevice não estiver na lista, ajuste-o

    if ((selectedDevice == null || !devices.contains(selectedDevice)) &&
        changedSelection) {
      selectedDevice = selectedDevice = devices.firstWhere(
        (element) => element.id == selectedDevice!.id,
        orElse: () => DiscoveredDevice(
            id: bluetoothLE['mainId'],
            name: bluetoothLE['mainId'],
            serviceData: const {},
            manufacturerData: Uint8List(0),
            rssi: 0,
            serviceUuids: const []),
      );
    }
  }

  bool isLoadingDevices = false;
  _init() async {
    setState(() {
      isLoadingDevices = true;
    });

    if (bluetoothLE["mainId"] != null && bluetoothLE["mainId"].isNotEmpty) {
      for (DiscoveredDevice device in devices) {
        if (device.id == bluetoothLE["mainId"]) {
          selectedDevice = device;
          break;
        }
      }
    }
    _getDevices();
    timer ??= Timer.periodic(const Duration(seconds: 1), (timer) async {
      _getDevices();
    });
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
              const SizedBox(height: kDefaultPadding),
              const Text(
                "Rede sem fio",
                style: TextStyle(
                    fontSize: 22,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300),
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
                          value: selectedDevice,
                          items: dropdownItems,
                          onChanged: (newValue) {
                            _getDevices();
                            setState(() {
                              changedSelection = true;
                              selectedDevice = devices.firstWhere(
                                  (element) => element.id == newValue!.id);
                            });
                          },
                        ),
                        const SizedBox(width: kDefaultPadding),
                        JMButton(
                          text: "Alterar",
                          onPressed: () async {
                            bluetoothLE['mainId'] = selectedDevice!.id;
                            Bluetooth().disconnect();
                          },
                        ),
                        const SizedBox(width: kDefaultPadding),
                        // JMButton(
                        //     text: '',
                        //     icon: const Icon(Icons.bluetooth),
                        //     onPressed: () {
                        //       const AndroidIntent(
                        //         action: 'android.settings.BLUETOOTH_SETTINGS',
                        //       ).launch();
                        //     }),
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
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: kDefaultPadding),
              Column(
                children: [
                  const Text(
                    "Controle largada e parada",
                    style: TextStyle(
                        fontSize: 22,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BooleanCard(
                          title: "Habilitar", id: 5, smallSize: true),
                      const SizedBox(width: kDefaultPadding / 2),
                      const ConfigCard(
                        id: 29,
                        title: "Calibração",
                        unit: "",
                        integer: false,
                        step: 0.01,
                        min: 0,
                        max: 100,
                      ),
                      const SizedBox(width: kDefaultPadding / 2),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: seedDropState.status == -1
                              ? kDisabledColor
                              : seedDropState.status == 0
                                  ? kErrorColor
                                  : kSuccessColor,
                          borderRadius:
                              BorderRadius.circular(kDefaultBorderSize),
                        ),
                        child: const Icon(
                          Icons.compass_calibration,
                          color: kSecondaryColor,
                          size: 26,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Configuração motores",
                    style: TextStyle(
                        fontSize: 22,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: kDefaultPadding / 2),
                            child: Container(
                              width: 320,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: kStrokeColor),
                                borderRadius:
                                    BorderRadius.circular(kDefaultBorderSize),
                              ),
                              child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: kDefaultPadding / 2),
                                      child: Text(
                                        'Semente',
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: kDefaultPadding / 4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ToogleButton(
                                            id: 1,
                                            firstText: '60',
                                            secoundText: '100',
                                          ),
                                          SizedBox(height: kDefaultPadding / 2),
                                          ToogleButton(
                                            id: 2,
                                            icon: true,
                                            rotate: true,
                                            firstIcon: Icons.refresh,
                                            secoundIcon: Icons.refresh,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          const SizedBox(width: kDefaultPadding / 2),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: kDefaultPadding / 2),
                            child: Container(
                              width: 320,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: kStrokeColor),
                                borderRadius:
                                    BorderRadius.circular(kDefaultBorderSize),
                              ),
                              child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: kDefaultPadding / 2),
                                      child: Text(
                                        'Adubo',
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: kDefaultPadding / 4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ToogleButton(
                                            id: 3,
                                            firstText: '60',
                                            secoundText: '100',
                                          ),
                                          SizedBox(height: kDefaultPadding / 2),
                                          ToogleButton(
                                            id: 4,
                                            icon: true,
                                            rotate: true,
                                            firstIcon: Icons.refresh,
                                            secoundIcon: Icons.refresh,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          const SizedBox(width: kDefaultPadding / 2),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: kDefaultPadding / 2),
                            child: Container(
                              width: 320,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: kStrokeColor),
                                borderRadius:
                                    BorderRadius.circular(kDefaultBorderSize),
                              ),
                              child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: kDefaultPadding / 2),
                                      child: Text(
                                        'Braquiária',
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: kDefaultPadding / 4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ToogleButton(
                                            id: 5,
                                            firstText: '60',
                                            secoundText: '100',
                                          ),
                                          SizedBox(height: kDefaultPadding / 2),
                                          ToogleButton(
                                            id: 6,
                                            icon: true,
                                            rotate: true,
                                            firstIcon: Icons.refresh,
                                            secoundIcon: Icons.refresh,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: kDefaultPadding),
              const Column(
                children: [
                  Text(
                    "Gravar logs",
                    style: TextStyle(
                        fontSize: 22,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BooleanCard(title: "Habilitar", id: 6, smallSize: false),
                    ],
                  ),
                  SizedBox(
                    height: kDefaultPadding,
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
