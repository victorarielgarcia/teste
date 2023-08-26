import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

errorDialog() {
  JMAlertBox(
          title: 'Acesso restrito',
          onPressed: () {},
          cancel: true,
          insetPadding: 0,
          body: const ErrorDialog())
      .openJMAlertBox(navigatorKey.currentContext);
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
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Para você conseguir acessar .",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
