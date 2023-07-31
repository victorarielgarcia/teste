import 'package:flutter/material.dart';

class ModuleVersionModel {
  List<int> version;
  ModuleVersionModel({required this.version});
}

class ModuleVersionManager extends ChangeNotifier {
  final ModuleVersionModel _state = ModuleVersionModel(version: []);

  ModuleVersionModel get state => _state;

  void update(List<int> version) {
    _state.version = version;
    notifyListeners();
  }
}
