import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

bluetoothLoseConnectionDialog() {
  JMAlertBox(
          title: 'Perda de conexão',
          onPressed: () {},
          cancel: false,
          ok: true,
          insetPadding: 0,
          errorType: 2,
          body: const BluetoothLoseConnectionDialog())
      .openJMAlertBox(navigatorKey.currentContext);
}

class BluetoothLoseConnectionDialog extends StatefulWidget {
  const BluetoothLoseConnectionDialog({
    super.key,
  });

  @override
  State<BluetoothLoseConnectionDialog> createState() =>
      _BluetoothLoseConnectionDialogState();
}

class _BluetoothLoseConnectionDialogState
    extends State<BluetoothLoseConnectionDialog> {
  @override
  void initState() {
    soundManager.playSound('error');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Houve uma falha na comunicação com os módulos, uma nova tentativa de conexão será realizada.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
