import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

moduleAddresingDialog() {
  JMAlertBox(
          title: 'Tempo de endereçamento excedido',
          onPressed: () {},
          dismissible: true,
          insetPadding: 0,
          body: const ModuleAddresingDialog())
      .openJMAlertBox(navigatorKey.currentContext);
}

class ModuleAddresingDialog extends StatefulWidget {
  const ModuleAddresingDialog({
    super.key,
  });

  @override
  State<ModuleAddresingDialog> createState() => _ModuleAddresingDialogState();
}

class _ModuleAddresingDialogState extends State<ModuleAddresingDialog> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Após clicar em \"endereçar\" é necessário conectar o módulo em até 3 minutos.",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
