
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/messages.dart';
import 'button.dart';

class ConfigCard extends StatefulWidget {
  final int id;
  final String title;
  final String unit;
  final int decimalPoint;

  final double min;
  final double max;
  final double step;
  final bool integer;

  const ConfigCard({
    super.key,
    required this.id,
    required this.title,
    required this.unit,
    required this.min,
    required this.max,
    this.step = 1,
    this.integer = true,
    this.decimalPoint = 2,
  });

  @override
  State<ConfigCard> createState() => _ConfigCardState();
}

class _ConfigCardState extends State<ConfigCard> {
  Soundpool? pool;
  int? soundId;

  final textEditingController = TextEditingController(text: '0');
  final focusNode = FocusNode();

  dynamic tempValue;
  @override
  void initState() {
    initSound();
    _setInitValue();
    super.initState();
  }

  @override
  void dispose() {
    if (textEditingController.text == '') {
      textEditingController.text = '0';
    }
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  _setInitValue() {
    switch (widget.id) {
      case 1:
        tempValue = machine['numberOfLines'];
        break;
      case 2:
        tempValue = machine['spacing'];
        break;
      case 3:
        // tempValue = machine['numberOfSections'];
        break;
      case 4:
        tempValue = seed['desiredRate'];
        break;
      case 5:
        tempValue = seed['numberOfHoles'];
        break;
      case 6:
        tempValue = seed['gearRatio'];
        break;
      case 7:
        tempValue = seed['firstErrorLimit'];
        break;
      case 8:
        tempValue = seed['secondErrorLimit'];
        break;
      case 9:
        tempValue = seed['errorCompensation'];
        break;
      case 10:
        tempValue = fertilizer['desiredRate'];
        break;
      case 11:
        tempValue = fertilizer['constantWeight'];
        break;
      case 12:
        tempValue = fertilizer['gearRatio'];
        break;
      case 13:
        tempValue = fertilizer['firstErrorLimit'];
        break;
      case 14:
        tempValue = fertilizer['secondErrorLimit'];
        break;
      case 15:
        tempValue = fertilizer['errorCompensation'];
        break;
      case 16:
        tempValue = brachiaria['desiredRate'];
        break;
      case 17:
        tempValue = brachiaria['constantWeight'];
        break;
      case 18:
        tempValue = brachiaria['gearRatio'];
        break;
      case 19:
        tempValue = brachiaria['firstErrorLimit'];
        break;
      case 20:
        tempValue = brachiaria['secondErrorLimit'];
        break;
      case 21:
        tempValue = brachiaria['errorCompensation'];
        break;
      case 22:
        tempValue = velocity['speed'];
        break;
      case 23:
        tempValue = velocity['errorCompensation'];
        break;
      case 24:
        tempValue = calibration['motorNumber'];
        break;
      case 25:
        tempValue = calibration['RPMToCalibrate'];
        break;
      case 26:
        tempValue = calibration['numberOfLaps'];
        break;
      case 27:
        tempValue = calibration['collectedWeight'];
        break;
      case 28:
        tempValue = calibration['numberOfLinesCollected'];
        break;
    }
    setState(() {
      textEditingController.text = tempValue.toString();
    });
  }

  Future<void> updateValues(String value) async {
    switch (widget.id) {
      case 1:
        if (machine['numberOfLines'] != int.parse(value)) {
          machine['sectionIndex'] = 0;
          machine['sectionsLayout'].clear();
          brachiaria['layout'].clear();
          fertilizer['layout'].clear();
        }
        machine['numberOfLines'] = int.parse(value);
        Messages().message['machine']!();
        break;
      case 2:
        machine['spacing'] = int.parse(value);
        Messages().message['machine']!();
        break;
      case 3:
        // machine['numberOfSections'] = int.parse(value);
        //  Messages().message['machine']!();
        break;
      case 4:
        seed['desiredRate'] = double.parse(value);
        Messages().message["seed"]!();
        break;
      case 5:
        seed['numberOfHoles'] = int.parse(value);
        Messages().message["seed"]!();
        break;
      case 6:
        seed['gearRatio'] = double.parse(value);
        Messages().message["seed"]!();
        break;
      case 7:
        seed['firstErrorLimit'] = double.parse(value);
        Messages().message["seed"]!();
        break;
      case 8:
        seed['secondErrorLimit'] = double.parse(value);
        Messages().message["seed"]!();
        break;
      case 9:
        seed['errorCompensation'] = double.parse(value);
        Messages().message["seed"]!();
        break;
      case 10:
        fertilizer['desiredRate'] = int.parse(value);
        Messages().message["fertilizer"]!();
        break;
      case 11:
        fertilizer['constantWeight'] = double.parse(value);
        Messages().message["fertilizer"]!();
        break;
      case 12:
        fertilizer['gearRatio'] = double.parse(value);
        Messages().message["fertilizer"]!();
        break;
      case 13:
        fertilizer['firstErrorLimit'] = double.parse(value);
        Messages().message["fertilizer"]!();
        break;
      case 14:
        fertilizer['secondErrorLimit'] = double.parse(value);
        Messages().message["fertilizer"]!();
        break;
      case 15:
        fertilizer['errorCompensation'] = double.parse(value);
        Messages().message["fertilizer"]!();
        break;
      case 16:
        brachiaria['desiredRate'] = double.parse(value);
        Messages().message["brachiaria"]!();
        break;
      case 17:
        brachiaria['constantWeight'] = double.parse(value);
        Messages().message["brachiaria"]!();
        break;
      case 18:
        brachiaria['gearRatio'] = double.parse(value);
        Messages().message["brachiaria"]!();
        break;
      case 19:
        brachiaria['firstErrorLimit'] = double.parse(value);
        Messages().message["brachiaria"]!();
        break;
      case 20:
        brachiaria['secondErrorLimit'] = double.parse(value);
        Messages().message["brachiaria"]!();
        break;
      case 21:
        brachiaria['errorCompensation'] = double.parse(value);
        Messages().message["brachiaria"]!();
        break;
      case 22:
        velocity['speed'] = double.parse(value);
        Messages().message["velocity"]!();
        break;
      case 23:
        velocity['errorCompensation'] = int.parse(value);
        Messages().message["velocity"]!();
        break;
      case 24:
        calibration['motorNumber'] = int.parse(value);
        break;
      case 25:
        calibration['RPMToCalibrate'] = int.parse(value);
        break;
      case 26:
        calibration['numberOfLaps'] = int.parse(value);
        break;
      case 27:
        calibration['collectedWeight'] = int.parse(value);
        break;
      case 28:
        calibration['numberOfLinesCollected'] = int.parse(value);
        break;
    }
  }

  Future initSound() async {
    pool = Soundpool.fromOptions();

    soundId = await rootBundle
        .load('assets/sounds/click.wav')
        .then((ByteData soundData) {
      return pool!.load(soundData);
    });
  }

  playSound() {
    pool!.play(soundId!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
      child: Container(
        width: 320,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kStrokeColor),
          borderRadius: BorderRadius.circular(kDefaultBorderSize),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      0, kDefaultPadding / 2, 0, kDefaultPadding / 4),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, kDefaultPadding, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IntrinsicWidth(
                        child: SizedBox(
                          height: 10,
                          child: TextField(
                            showCursor: false,
                            controller: textEditingController,
                            focusNode: focusNode,
                            inputFormatters: widget.integer
                                ? [
                                    LengthLimitingTextInputFormatter(
                                        widget.max.toInt().toString().length),

                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'[0-9]')), // Permite apenas números

                                    FilteringTextInputFormatter.deny(RegExp(
                                        r'^0+')), // Não permite zeros à esquerda
                                  ]
                                : [
                                    LengthLimitingTextInputFormatter(
                                        widget.max.toString().length),
                                  ],
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                if (double.parse(value) > widget.max) {
                                  textEditingController.text =
                                      widget.max.toInt().toString();
                                } else if (double.parse(value) < widget.min) {
                                  textEditingController.text =
                                      widget.min.toInt().toString();
                                }
                              } else {
                                textEditingController.text =
                                    tempValue.toString();

                                // widget.integer
                                //     ? textEditingController.text =
                                //         widget.min.toInt().toString()
                                //     : textEditingController.text =
                                //         widget.min.toString();
                              }
                              updateValues(textEditingController.text);
                              focusNode.unfocus();
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 34),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' ${widget.unit}',
                        style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 158.5,
                      height: 50,
                      child: JMButton(
                        text: '-',
                        onPressed: () {
                        
                          if (double.parse(textEditingController.text) >
                              widget.min) {
                            textEditingController.text = widget.integer
                                ? (int.parse(textEditingController.text) -
                                        (widget.step.toInt()))
                                    .toString()
                                : (double.parse(textEditingController.text) -
                                        widget.step)
                                    .toStringAsFixed(widget.decimalPoint);
                          }
                          updateValues(textEditingController.text);
                          focusNode.unfocus();
                        },
                        lessButton: true,
                      ),
                    ),
                    Container(color: kSecondaryColor, height: 50, width: 1),
                    SizedBox(
                      width: 158.5,
                      height: 50,
                      child: JMButton(
                        text: '+',
                        onPressed: () {
                     
                          if (double.parse(textEditingController.text) <
                              widget.max) {
                            textEditingController.text = widget.integer
                                ? (int.parse(textEditingController.text) +
                                        (widget.step.toInt()))
                                    .toString()
                                : (double.parse(textEditingController.text) +
                                        widget.step)
                                    .toStringAsFixed(widget.decimalPoint);
                          }
                          updateValues(textEditingController.text);
                          focusNode.unfocus();
                        },
                        moreButton: true,
                      ),
                    ),
                  ],
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                textEditingController.text = "";
                focusNode.requestFocus();
              },
              child: Container(
                color: Colors.transparent,
                width: 320,
                height: 118,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
