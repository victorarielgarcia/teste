import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

errorDialog() {
  JMAlertBox(
    title: 'Desempenho do Motor',
    onPressed: () {
      // acceptedDialog['error'] = true;
    },
    cancel: false,
    ok: true,
    onCancel: () {
      // acceptedDialog['error'] = true;
    },
    insetPadding: 0,
    errorType: 2,
    body: const ErrorDialog(),
  ).openJMAlertBox(navigatorKey.currentContext);
}

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({
    super.key,
  });

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  void initState() {
    soundManager.playSound('error');
    acceptedDialog['error'] = false;
    super.initState();
  }

  @override
  void dispose() {
    // acceptedDialog['error'] = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "A rotação do motor está significativamente fora dos parâmetros desejados. Recomendamos a verificação imediata para evitar danos ou problemas de performance.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
