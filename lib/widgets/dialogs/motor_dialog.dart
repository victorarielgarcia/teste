import 'package:easytech_electric_blue/utilities/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/sizes.dart';
import '../alert_box.dart';
import '../button.dart';
import '../simple_card.dart';

motorDialog(int index, String name) {
  JMAlertBox(
          title: 'Informações avançadas do motor',
          width: 700,
          onPressed: () {},
          dismissible: true,
          // cancel: true,
          // ok: false,
          insetPadding: 0,
          body: MotorDialog(index: index, name: name))
      .openJMAlertBox(navigatorKey.currentContext);
}

class MotorDialog extends StatefulWidget {
  final int index;
  final String name;
  const MotorDialog({
    super.key,
    required this.index,
    required this.name,
  });

  @override
  State<MotorDialog> createState() => _AdvancedDialogState();
}

class _AdvancedDialogState extends State<MotorDialog> {
  Soundpool? pool;
  int? soundId;

  @override
  void initState() {
    super.initState();
    initSound();
  }

  Future initSound() async {
    pool = Soundpool.fromOptions();

    soundId = await rootBundle
        .load('assets/sounds/error.mp3')
        .then((ByteData soundData) {
      return pool!.load(soundData);
    });
  }

  playSound() {
    pool!.play(soundId!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${widget.name} ${widget.index + 1}',
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.w300, color: kPrimaryColor),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleCard(
                title: 'Temperatura', text: '100', unit: '°C', width: 180),
            SizedBox(width: kDefaultPadding / 2),
            SimpleCard(title: 'Corrente', text: '4.0', unit: 'A', width: 180),
            SizedBox(width: kDefaultPadding / 2),
            SimpleCard(title: 'Tensão', text: '27.5', unit: 'V', width: 180),
          ],
        ),
        const SizedBox(height: kDefaultPadding / 2),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleCard(
                title: 'RPM alvo', text: '22.7', unit: 'RPM', width: 280),
            SizedBox(width: kDefaultPadding / 2),
            SimpleCard(
                title: 'RPM atual', text: '22.6', unit: 'RPM', width: 280),
          ],
        ),
        const SizedBox(height: kDefaultPadding / 2),
        const SimpleCard(
            title: 'Mensagem de erro',
            text: 'Temperatura alta',
            textFontSize: 24,
            width: 580),
        const SizedBox(height: kDefaultPadding),
        SizedBox(
          width: 220,
          height: 60,
          child: JMButton(
              text: 'Resetar motor',
              onPressed: () {
                playSound();
              }),
        ),
      ],
    );
  }
}
