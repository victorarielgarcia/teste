import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

advancedDialog(BuildContext context) {
  JMAlertBox(
          title: 'Acesso restrito',
          onPressed: () {},
       cancel: true,
          insetPadding: 0,
          body: const AdvancedDialog())
      .openJMAlertBox(context);
}

class AdvancedDialog extends StatefulWidget {
  const AdvancedDialog({
    super.key,
  });

  @override
  State<AdvancedDialog> createState() => _AdvancedDialogState();
}

class _AdvancedDialogState extends State<AdvancedDialog> {
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
