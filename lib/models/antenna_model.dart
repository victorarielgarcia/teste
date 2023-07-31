import 'package:flutter/material.dart';

import '../utilities/global.dart';

class AntennaModel {
  double speed;
  AntennaModel({required this.speed});
}

class AntennaManager extends ChangeNotifier {
  final AntennaModel _state = AntennaModel(speed: 0.0);

  AntennaModel get state => _state;

  void updateSpeed(double speed) {
    _state.speed = speed;
    antenna['speed'] = speed;
    notifyListeners();
  }
}
