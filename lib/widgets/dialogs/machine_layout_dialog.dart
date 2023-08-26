import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

machineLayoutDialog() {
  JMAlertBox(
          title: 'Layout inválido',
          onPressed: () {},
          dismissible: true,
          insetPadding: 0,
          body: const MachineLayoutDialog())
      .openJMAlertBox(navigatorKey.currentContext);
}

class MachineLayoutDialog extends StatefulWidget {
  const MachineLayoutDialog({
    super.key,
  });

  @override
  State<MachineLayoutDialog> createState() => _MachineLayoutDialogState();
}

class _MachineLayoutDialogState extends State<MachineLayoutDialog> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "As alterações realizadas não atendem o layout da máquina, o total das linhas das caixas deve ser o mesmo que a quantidade de linhas das máquinas",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
