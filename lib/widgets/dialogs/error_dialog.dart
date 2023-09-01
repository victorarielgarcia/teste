import 'package:easytech_electric_blue/utilities/constants/colors.dart';
import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:easytech_electric_blue/widgets/card.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';

errorDialog(int group, List motors) {
  String groupName = "";
  if (group == 1) {
    groupName = "semente";
  }  if (group == 2) {
    groupName = "adubo";
  } else if (group == 3) {
    groupName = "braquiária";
  }
  JMAlertBox(
    title: 'Desempenho do motor de $groupName',
    onPressed: () {
      if (group == 1) {
        acceptedDialog['seedError'] = true;
      }  if (group == 2) {
        acceptedDialog['fertilizerError'] = true;
      }  if (group == 3) {
        acceptedDialog['brachiariaError'] = true;
      }
    },
    cancel: false,
    ok: true,
    onCancel: () {
      if (group == 1) {
        acceptedDialog['seedError'] = true;
      }  if (group == 2) {
        acceptedDialog['fertilizerError'] = true;
      }  if (group == 3) {
        acceptedDialog['brachiariaError'] = true;
      }
    },
    width: 680,
    insetPadding: 0,
    errorType: 2,
    body: ErrorDialog(groupName: groupName, group: group, motors: motors),
  ).openJMAlertBox(navigatorKey.currentContext);
}

class ErrorDialog extends StatefulWidget {
  final List motors;
  final String groupName;
  final int group;
  const ErrorDialog({
    super.key,
    required this.motors,
    required this.groupName,
    required this.group,
  });

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  void initState() {
    if (widget.group == 1) {
      acceptedDialog['seedError'] = false;
    }  if (widget.group == 2) {
      acceptedDialog['fertilizerError'] = false;
    }  if (widget.group == 3) {
      acceptedDialog['brachiariaError'] = false;
    }
    soundManager.playSound('error');
    super.initState();
  }

  @override
  void dispose() {
    if (widget.group == 1) {
      acceptedDialog['seedError'] = true;
    } else if (widget.group == 2) {
      acceptedDialog['fertilizerError'] = true;
    } else if (widget.group == 3) {
      acceptedDialog['brachiariaError'] = true;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: kDefaultPadding / 2),
        Text(
          "A rotação do motor de ${widget.groupName} está significativamente fora dos parâmetros desejados.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(top: kDefaultPadding) / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Motores",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: kDefaultPadding / 4),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: kDefaultPadding / 4,
                  runSpacing: kDefaultPadding / 4,
                  children: List.generate(widget.motors.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding / 4),
                      child: JMCard(
                        width: 40,
                        height: 40,
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
