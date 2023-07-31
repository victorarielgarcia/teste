import 'package:easytech_electric_blue/utilities/constants/colors.dart';
import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:flutter/material.dart';

class LiftSensor {
  int getSelectableOption() {
    int selectableOption = 0;
    if (liftSensor['options'] == 1) {
      if (liftSensor['normallyOpen']) {
        selectableOption = 2;
      } else {
        selectableOption = 3;
      }
    } else if (liftSensor['options'] == 2) {
      if (liftSensor['manualMachineLifted']) {
        selectableOption = 0;
      } else {
        selectableOption = 1;
      }
    }
    // print("SELECTABLE: $selectableOption");

    return selectableOption;
  }
}

class LiftSensorModel {
  bool machineLifted;
  Color color;
  LiftSensorModel({required this.machineLifted, this.color = kDisabledColor});
}

class LiftSensorManager extends ChangeNotifier {
  final LiftSensorModel _state =
      LiftSensorModel(machineLifted: false, color: kDisabledColor);

  LiftSensorModel get state => _state;

  void update(bool machineLifted) {
    _state.machineLifted = machineLifted;
    double speed = 0.0;
    if (velocity['options'] == 1) {
      speed = antenna['speed'];
    } else if (velocity['options'] == 2) {
      speed = nmea['speed'];
    } else if (velocity['options'] == 3) {
     
      speed = velocity['speed'];
    }

    if (speed > 0 && machineLifted) {
      _state.color = kSuccessColor;
    } else if (speed > 0 && !machineLifted) {
      _state.color = kWarningColor;
    } else {
      _state.color = kDisabledColor;
    }
    notifyListeners();
  }
}
