import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/utilities/messages.dart';
import 'package:easytech_electric_blue/widgets/button.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

bluetoothLoseConnectionDialog() {
  JMAlertBox(
          title: 'Perda de conexão',
          onPressed: () {},
          cancel: false,
          ok: false,
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Os motores foram parados e permanecerão desativados até que seja tomada uma ação.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: kDefaultPadding * 1.5),
        Center(
            child: SizedBox(
                height: 70,
                width: 200,
                child: JMButton(
                    text: "Retomar motores",
                    onPressed: () {
                      machine['stoppedMotors'] = false;
                      Messages().message["startMotors"]!();
                      Navigator.of(context).pop();
                    }))),
        const SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
