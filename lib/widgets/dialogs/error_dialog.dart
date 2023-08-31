import 'package:easytech_electric_blue/utilities/constants/colors.dart';
import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/widgets/card.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

errorDialog(String groupName, List motors) {
  JMAlertBox(
    title: 'Desempenho do motor de $groupName',
    onPressed: () {
      // acceptedDialog['error'] = true;
    },
    cancel: false,
    ok: true,
    onCancel: () {
      // acceptedDialog['error'] = true;
    },
    width: 800,
    insetPadding: 0,
    errorType: 2,
    body: ErrorDialog(groupName: groupName, motors: motors),
  ).openJMAlertBox(navigatorKey.currentContext);
}

class ErrorDialog extends StatefulWidget {
  final List motors;
  final String groupName;
  const ErrorDialog({
    super.key,
    required this.motors,
    required this.groupName,
  });

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  void initState() {
    acceptedDialog['error'] = false;
    soundManager.playSound('error');

    super.initState();
  }

  @override
  void dispose() {
    // acceptedDialog['error'] = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "A rotação do motor de ${widget.groupName} está significativamente fora dos parâmetros desejados.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              const Text(
                "Motores",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: kDefaultPadding / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.motors.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 4),
                    child: JMCard(
                      width: 70,
                      height: 70,
                      backgroundColor: kSecondaryColor,
                      body: Center(
                          child: Text(
                        widget.motors[index].toString(),
                        style: const TextStyle(fontSize: 16),
                      )),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // Text(
        //   "A rotação do motor está significativamente fora dos parâmetros desejados. Recomendamos a verificação imediata para evitar danos ou problemas de performance.",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(fontSize: 13),
        // ),
        const SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
