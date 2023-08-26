import 'package:easytech_electric_blue/widgets/dialogs/bluetooth_lose_connection_dialog.dart';
import 'package:flutter/material.dart';

class BluetoothModel {
  bool connected;
  BluetoothModel({required this.connected});
}

class BluetoothManager extends ChangeNotifier {
  final BluetoothModel _state = BluetoothModel(connected: false);

  BluetoothModel get state => _state;

  void changeConnectionState(bool connected) {
    // if (_state.connected && !connected) {
    //   bluetoothLoseConnectionDialog();
    // }
    _state.connected = connected;
    notifyListeners();
  }
}
