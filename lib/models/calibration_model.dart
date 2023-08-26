import 'package:flutter/material.dart';

class CalibrationModel {
  int porcentage;
  CalibrationModel({required this.porcentage});
}

class CalibrationManager extends ChangeNotifier {
  final CalibrationModel _state = CalibrationModel(porcentage: 0);

  CalibrationModel get state => _state;

  void update(int porcentage) {
    _state.porcentage = porcentage;
    notifyListeners();
  }
}
