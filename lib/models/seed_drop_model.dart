import 'package:flutter/material.dart';

class SeedDropModel {
  int status;
  SeedDropModel({required this.status});
}

class SeedDropManager extends ChangeNotifier {
  final SeedDropModel _state = SeedDropModel(status: -1);

  SeedDropModel get state => _state;

  void update(int status) {
    _state.status = status;
    notifyListeners();
  }
}
