import 'package:flutter/material.dart';

import '../utilities/global.dart';

class ModuleAddressingModel {
  int moduleAddresing;
  int status;
  ModuleAddressingModel({required this.moduleAddresing, required this.status});
}

class ModuleAddresingManager extends ChangeNotifier {
  final ModuleAddressingModel _state =
      ModuleAddressingModel(moduleAddresing: -1, status: -1);

  ModuleAddressingModel get state => _state;

  void update(int moduleAddresing, int status) {
    _state.moduleAddresing = moduleAddresing;
    _state.status = status;
    module['addressed'].length > moduleAddresing - 1
        ? module['addressed'][moduleAddresing - 1] = status
        : module['addressed'].add(status);
    notifyListeners();
  }
}
