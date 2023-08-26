import 'package:flutter/material.dart';
import '../models/lift_sensor_model.dart';
import '../screens/machine_screen.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/messages.dart';

class BooleanCard extends StatefulWidget {
  final String title;
  final String secondTitle;
  final int id;
  final bool smallSize;
  const BooleanCard({
    super.key,
    required this.title,
    required this.id,
    this.smallSize = false,
    this.secondTitle = '',
  });

  @override
  State<BooleanCard> createState() => _BooleanCardState();
}

class _BooleanCardState extends State<BooleanCard> {
  bool variable = false;

  @override
  void initState() {
    _setInitValue();
    super.initState();
  }

  _setInitValue() {
    bool tempValue = false;
    switch (widget.id) {
      case 1:
        tempValue = machine['fertilizer'];
        break;
      case 2:
        tempValue = machine['brachiaria'];
        break;
      case 3:
        tempValue = liftSensor['normallyOpen'];
        break;
      case 4:
        tempValue = liftSensor['manualMachineLifted'];
        break;
      case 5:
        tempValue = seedDropControl['enabled'];
        break;
    }
    setState(() {
      variable = tempValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
      child: Container(
        width: widget.smallSize ? 160 : 320,
        height: 170,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    variable
                        ? widget.title
                        : widget.secondTitle != ''
                            ? widget.secondTitle
                            : widget.title,
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Padding(
                    padding: const EdgeInsets.only(left: kDefaultPadding / 2),
                    child: Transform.scale(
                      scale: 2.0,
                      child: Switch(
                        value: variable,
                        activeColor: kSuccessColor,
                        onChanged: (bool value) {
                          soundManager.playSound('click');
                          variable = !variable;
                          switch (widget.id) {
                            case 1:
                              setState(() {
                                machine['fertilizer'] = variable;
                              });
                              Messages().message["fertilizer"]!();
                              Future.delayed(
                                const Duration(milliseconds: 400),
                                () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      MachineScreen.route, (route) => false);
                                },
                              );
                              break;
                            case 2:
                              setState(() {
                                machine['brachiaria'] = variable;
                              });
                              Messages().message["brachiaria"]!();
                              Future.delayed(
                                const Duration(milliseconds: 400),
                                () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      MachineScreen.route, (route) => false);
                                },
                              );
                              break;
                            case 3:
                              setState(() {
                                liftSensor['normallyOpen'] = variable;
                              });
                              liftSensor['manualMachineLifted'] = false;
                              Messages().message["sensor"]!(
                                  LiftSensor().getSelectableOption());

                              break;
                            case 4:
                              setState(() {
                                liftSensor['manualMachineLifted'] = variable;
                              });
                              liftSensor['normallyOpen'] = false;
                              liftSensorManager
                                  .update(!liftSensor['manualMachineLifted']);
                              Messages().message["sensor"]!(
                                  LiftSensor().getSelectableOption());
                              break;
                            case 5:
                              setState(() {
                                seedDropControl['enabled'] = variable;
                              });
                              seedDropManager.update(variable ? 0 : -1);
                              break;
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
