import 'package:flutter/material.dart';

class MotorModel {
  List<double> rpm;
  double targetRPMBrachiaria;

  double targetRPMFertilizer;
  double targetRPMSeed;

  MotorModel({
    required this.rpm,
    required this.targetRPMBrachiaria,
    required this.targetRPMFertilizer,
    required this.targetRPMSeed,
  });
}

class MotorManager extends ChangeNotifier {
  final MotorModel _state = MotorModel(
    rpm: [
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
    ],
    targetRPMBrachiaria: 0.0,
    targetRPMFertilizer: 0.0,
    targetRPMSeed: 0.0,
  );

  MotorModel get state => _state;

  void updateRPM(
    List<double> rpm,
    double targetRPMBrachiaria,
    double targetRPMFertilizer,
    double targetRPMSeed,
  ) {
    _state.rpm = rpm;
    _state.targetRPMBrachiaria = targetRPMBrachiaria;
    _state.targetRPMFertilizer = targetRPMFertilizer;
    _state.targetRPMSeed = targetRPMSeed;
    notifyListeners();
  }
}
