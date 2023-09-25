import 'package:easytech_electric_blue/services/lock_task.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/bluetooth.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/top_bar.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  static const String route = '/support';

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  void initState() {
    if (connected) {
      Bluetooth().currentScreen(context, 80);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: JMBottomNavigationBar(
        onExit: () {
          LockTask.enable();
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
                "Suporte",
                style: TextStyle(
                    fontSize: 22,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              SupportCard(
                                title: 'Acesso Remoto',
                                icon: SvgPicture.asset(
                                  'assets/icons/remote_access.svg',
                                ),
                                function: () async {
                                  LockTask.disable();
                                  await LaunchApp.openApp(
                                    androidPackageName:
                                        'com.carriez.flutter_hbb',
                                  );
                                },
                              ),
                              // const SizedBox(width: kDefaultPadding),
                              // SupportCard(
                              //   title: 'Jumil Serviços',
                              //   icon: Image.asset('assets/images/jms.png'),
                              //   function: () async {
                              //     await LaunchApp.openApp(
                              //       androidPackageName: 'br.com.jumil.servicos',
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                          const SizedBox(height: kDefaultPadding),
                          const Row(
                            children: [
                              // SupportCard(
                              //   title: 'Loja',
                              //   icon: SvgPicture.asset(
                              //     'assets/icons/remote_access.svg',
                              //   ),
                              //   function: () async {
                              //     await LaunchApp.openApp(
                              //       androidPackageName:
                              //           'com.teamviewer.quicksupport.market',
                              //     );
                              //   },
                              // ),
                              // const SizedBox(width: kDefaultPadding),
                              // SupportCard(
                              //   title: 'Jumil Serviços',
                              //   icon: Image.asset('assets/images/jms.png'),
                              //   function: () async {
                              //     await LaunchApp.openApp(
                              //       androidPackageName:
                              //           'com.teamviewer.quicksupport.market',
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: kDefaultPadding * 3),
                      Container(
                        width: 1,
                        height: 550,
                        color: kStrokeColor,
                      ),
                      const SizedBox(width: kDefaultPadding * 3),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Av. Gen. Osório, 1460 - Riachuelo, Batatais - SP, 14315-350",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                          Text(
                            "Tel. +55 (16) 3660-1000",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                          SizedBox(height: kDefaultPadding / 2),
                          Text(
                            "Horário de atendimento",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                          Text(
                            "Segunda à Sexta das 07:00 às 17:48.",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SupportCard extends StatelessWidget {
  final String title;
  final Function()? function;

  final Widget icon;

  const SupportCard({
    super.key,
    required this.title,
    required this.icon,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 250,
        height: 223,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kStrokeColor),
          borderRadius: BorderRadius.circular(kDefaultBorderSize),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    0, kDefaultPadding / 2, 0, kDefaultPadding / 4),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    SizedBox(height: 80, child: icon),
                    const SizedBox(height: kDefaultPadding),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 248,
                    height: 60,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        border: Border.all(color: kStrokeColor),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(kDefaultBorderSize),
                        )),
                    child: const Center(
                        child: Text(
                      "Abrir",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
