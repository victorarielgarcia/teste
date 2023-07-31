import 'package:flutter/material.dart';

class MotorAddressingModel {
  List<int> brachiariaAddressed;
  List<int> fertilizerAddressed;
  List<int> seedAddressed;
  MotorAddressingModel(
      {required this.brachiariaAddressed,
      required this.fertilizerAddressed,
      required this.seedAddressed});
}

class MotorAddressingManager extends ChangeNotifier {
  final MotorAddressingModel _state = MotorAddressingModel(
      brachiariaAddressed: [], fertilizerAddressed: [], seedAddressed: []);

  MotorAddressingModel get state => _state;

  void update(
    List<dynamic> brachiariaAddressed,
    List<dynamic> fertilizerAddressed,
    List<dynamic> seedAddressed,
  ) {
    _state.brachiariaAddressed = brachiariaAddressed.cast<int>();
    _state.fertilizerAddressed = fertilizerAddressed.cast<int>();
    _state.seedAddressed = seedAddressed.cast<int>();
    notifyListeners();
  }
}
