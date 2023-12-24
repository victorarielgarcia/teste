import 'package:easytech_electric_blue/utilities/messages.dart';
import 'package:easytech_electric_blue/widgets/button.dart';
import 'package:easytech_electric_blue/widgets/dialogs/stop_motors_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../screens/advanced_screen.dart';
import '../screens/brachiaria_calibration_result_screen.dart';
import '../screens/brachiaria_calibration_screen.dart';
import '../screens/brachiaria_screen.dart';
import '../screens/fertilizer_calibration_result_screen.dart';
import '../screens/fertilizer_calibration_screen.dart';
import '../screens/fertilizer_screen.dart';
import '../screens/machine_layout_screen.dart';
import '../screens/machine_screen.dart';
import '../screens/module_addressing_screen.dart';
import '../screens/motor_addressing_screen.dart';
import '../screens/motor_screen.dart';
import '../screens/sections_layout_screen.dart';
import '../screens/seed_screen.dart';
import '../screens/sensor_screen.dart';
import '../screens/support_screen.dart';
import '../screens/velocity_screen.dart';
import '../screens/work_screen.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';

double scrollOffset = 0.0;

class JMBottomNavigationBar extends StatefulWidget {
  final Function onExit;

  const JMBottomNavigationBar({
    super.key,
    required this.onExit,
  });

  @override
  State<JMBottomNavigationBar> createState() => _JMBottomNavigationBarState();
}

class _JMBottomNavigationBarState extends State<JMBottomNavigationBar> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollOffset);
      }
    });
    scrollController.addListener(() {
      scrollOffset = scrollController.offset;
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
            horizontal: BorderSide(
          color: kStrokeColor,
        )),
      ),
      height: 70,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.decelerate);
              }
            },
            child: Container(
              color: Colors.transparent,
              height: 60,
              width: 60,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: kJumilColor,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              children: [
                BottomNavigationItem(
                  label: 'Trabalho',
                  iconAsset: 'assets/icons/work.svg',
                  route: WorkScreen.route,
                  selected:
                      ModalRoute.of(context)?.settings.name == WorkScreen.route
                          ? true
                          : false,
                  onExit: widget.onExit,
                ),
                BottomNavigationItem(
                  label: 'Motores',
                  iconAsset: 'assets/icons/motor.svg',
                  route: MotorScreen.route,
                  selected:
                      ModalRoute.of(context)?.settings.name == MotorScreen.route
                          ? true
                          : false,
                  onExit: widget.onExit,
                ),
                BottomNavigationItem(
                  label: 'Semente',
                  iconAsset: 'assets/icons/seed.svg',
                  route: SeedScreen.route,
                  selected:
                      ModalRoute.of(context)?.settings.name == SeedScreen.route
                          ? true
                          : false,
                  onExit: widget.onExit,
                ),
                !machine['fertilizer']
                    ? const SizedBox()
                    : BottomNavigationItem(
                        label: 'Adubo',
                        iconAsset: 'assets/icons/fertilizer.svg',
                        route: FertilizerScreen.route,
                        selected: ModalRoute.of(context)?.settings.name ==
                                FertilizerScreen.route
                            ? true
                            : ModalRoute.of(context)?.settings.name ==
                                    FertilizerCalibrationScreen.route
                                ? true
                                : ModalRoute.of(context)?.settings.name ==
                                        FertilizerCalibrationResultScreen.route
                                    ? true
                                    : false,
                        onExit: widget.onExit,
                      ),
                !machine['brachiaria']
                    ? const SizedBox()
                    : BottomNavigationItem(
                        label: 'Braquiária',
                        iconAsset: 'assets/icons/brachiaria.svg',
                        route: BrachiariaScreen.route,
                        selected: ModalRoute.of(context)?.settings.name ==
                                BrachiariaScreen.route
                            ? true
                            : ModalRoute.of(context)?.settings.name ==
                                    BrachiariaCalibrationScreen.route
                                ? true
                                : ModalRoute.of(context)?.settings.name ==
                                        BrachiariaCalibrationResultScreen.route
                                    ? true
                                    : false,
                        onExit: widget.onExit,
                      ),
                BottomNavigationItem(
                  label: 'Plantadeira',
                  iconAsset: 'assets/icons/planter_machine.svg',
                  route: MachineScreen.route,
                  selected: ModalRoute.of(context)?.settings.name ==
                          MachineScreen.route
                      ? true
                      : ModalRoute.of(context)?.settings.name ==
                              SectionsLayoutScreen.route
                          ? true
                          : ModalRoute.of(context)?.settings.name ==
                                  MachineLayoutScreen.route
                              ? true
                              : false,
                  onExit: widget.onExit,
                ),
                BottomNavigationItem(
                  label: 'Velocidade',
                  iconAsset: 'assets/icons/velocity.svg',
                  route: VelocityScreen.route,
                  selected: ModalRoute.of(context)?.settings.name ==
                          VelocityScreen.route
                      ? true
                      : false,
                  onExit: widget.onExit,
                ),
                BottomNavigationItem(
                  label: 'Sensores',
                  iconAsset: 'assets/icons/sensor.svg',
                  route: SensorScreen.route,
                  selected: ModalRoute.of(context)?.settings.name ==
                      SensorScreen.route,
                  onExit: widget.onExit,
                ),
                // BottomNavigationItem(
                //   label: 'Acumulados',
                //   iconAsset: 'assets/icons/area.svg',
                //   route: WorkScreen.route,
                //   selected: false,
                //   onExit: widget.onExit,
                // ),

                BottomNavigationItem(
                  label: 'Suporte',
                  iconAsset: 'assets/icons/support.svg',
                  route: SupportScreen.route,
                  selected: ModalRoute.of(context)?.settings.name ==
                          SupportScreen.route
                      ? true
                      : false,
                  onExit: widget.onExit,
                ),
                BottomNavigationItem(
                  label: 'Avançado',
                  iconAsset: 'assets/icons/padlock.svg',
                  route: AdvancedScreen.route,
                  selected: ModalRoute.of(context)?.settings.name ==
                          AdvancedScreen.route
                      ? true
                      : ModalRoute.of(context)?.settings.name ==
                              ModuleAddressingScreen.route
                          ? true
                          : ModalRoute.of(context)?.settings.name ==
                                  MotorAddressingScreen.route
                              ? true
                              : false,
                  onExit: widget.onExit,
                ),
              ],
            ),
          ),
          // Forward Button Icon
          GestureDetector(
            onTap: () {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.decelerate);
              }
            },
            child: Container(
              color: Colors.transparent,
              height: 60,
              width: 60,
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: kJumilColor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
                right: kDefaultPadding, left: kDefaultPadding),
            child: SizedBox(
              width: 160,
              height: 55,
              child: JMButton(
                  text: "Parar motores",
                  backgroundColor: kErrorColor,
                  foregroundColor: kSecondaryColor,
                  onPressed: () {
                    setState(() {
                      machine['stoppedMotors'] = true;
                      Messages().message["stopMotors"]!();
                    });
                    stopMotorsDialog();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  final String label;
  final String iconAsset;
  final bool selected;
  final String route;
  final Function onExit;
  const BottomNavigationItem({
    super.key,
    required this.selected,
    required this.iconAsset,
    required this.label,
    required this.route,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kDefaultBorderSize),
        child: InkWell(
          onTap: () {
            soundManager.playSound('click');

            if (ModalRoute.of(context)?.settings.name != route) {
              onExit();
              Navigator.of(context).pushNamedAndRemoveUntil(
                route,
                (route) => false,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  selected ? kJumilColor.withOpacity(0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(kDefaultBorderSize),
              // border: Border.all(color: selected? Colors.transparent: kStrokeColor)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: selected ? 30.0 : 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    child: SvgPicture.asset(
                      iconAsset,
                      colorFilter: ColorFilter.mode(
                        selected ? kJumilColor : kDisabledColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(
                        color: selected ? kJumilColor : kDisabledColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
