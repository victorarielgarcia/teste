import 'package:flutter/material.dart';

class SeedModel {
  List<double> rate;
  SeedModel({required this.rate});
}

class SeedManager extends ChangeNotifier {
  final SeedModel _state = SeedModel(rate: []);

  SeedModel get state => _state;

  void updateRate(List<double> rate) {
    _state.rate = rate;
    notifyListeners();
  }
}
