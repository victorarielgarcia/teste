import 'package:flutter/material.dart';

class BluetoothModel {
  bool connected;
  BluetoothModel({required this.connected});
}

class BluetoothManager extends ChangeNotifier {
  final BluetoothModel _state = BluetoothModel(connected: false);

  BluetoothModel get state => _state;

  void changeConnectionState(bool connected) {
    _state.connected = connected;
    notifyListeners();
  }
}
