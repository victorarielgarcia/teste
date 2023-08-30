import 'package:easytech_electric_blue/services/speed.dart';
import 'package:flutter/material.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';

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
    double speed = Speed.getCurrentVelocity();
    if (speed > 0 && machineLifted) {
      _state.color = kSuccessColor;
      // connected ? error['isPlanting'] = true : error['isPlanting'] = false;
      status['isPlanting'] = true;
    } else if (speed > 0 && !machineLifted) {
      _state.color = kWarningColor;
      status['isPlanting'] = false;
    } else {
      _state.color = kDisabledColor;
      status['isPlanting'] = false;
      status['showMonitoring'] = false;
    }
    notifyListeners();
  }
}
