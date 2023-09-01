import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/utilities/messages.dart';
import 'package:easytech_electric_blue/widgets/button.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

stopMotorsDialog() {
  JMAlertBox(
          title: 'Motores parados',
          onPressed: () {},
          cancel: false,
          ok: false,
          insetPadding: 0,
          errorType: 1,
          body: const StopMotorsDialog())
      .openJMAlertBox(navigatorKey.currentContext);
}

class StopMotorsDialog extends StatefulWidget {
  const StopMotorsDialog({
    super.key,
  });

  @override
  State<StopMotorsDialog> createState() => _StopMotorsDialogState();
}

class _StopMotorsDialogState extends State<StopMotorsDialog> {
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
