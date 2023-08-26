import 'package:flutter/material.dart';

import '../utilities/charts.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';
import '../utilities/messages.dart';
import 'dialogs/set_motors_dialog.dart';

class SectionCut extends StatefulWidget {
  const SectionCut({
    super.key,
  });

  @override
  State<SectionCut> createState() => _SectionCutState();
}

class _SectionCutState extends State<SectionCut> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Charts.getGroupSpace()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
            machine['sectionsLayout'].asMap().entries.map<Widget>((entry) {
          int id = entry.key + 1;
          int data = entry.value;
          return Row(
            children: [
              SectionCutButton(numberOfLines: data, id: id),
              SizedBox(width: Charts.getGroupSpace()),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class SectionCutButton extends StatefulWidget {
  final int numberOfLines;
  final int id;
  const SectionCutButton({
    super.key,
    required this.numberOfLines,
    required this.id,
  });

  @override
  State<SectionCutButton> createState() => _SectionCutButtonState();
}

class _SectionCutButtonState extends State<SectionCutButton> {
  double minHeight = 30.0;
  double maxHeight = 290;
  double containerHeight = 30.0;
  double opacityControl = 1;
  bool cutSection = false;

  @override
  void initState() {
    if (machine['brachiaria'] && machine['fertilizer']) {
      maxHeight = 290;
    } else if ((machine['brachiaria'] || machine['fertilizer']) ||
        (!machine['brachiaria'] && !machine['fertilizer'])) {
      maxHeight = 245;
    }
    try {
      if (section['cutted'][widget.id - 1]) {
        setState(() {
          containerHeight = maxHeight;
          cutSection = true;
        });
      }
    } catch (e) {
      section['cutted'].add(false);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 125),
              height: containerHeight,
              width: ((widget.numberOfLines - 1) * Charts.getGroupSpace() +
                  widget.numberOfLines * 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultBorderSize),
                  color: cutSection
                      ? kErrorColor.withOpacity(0.15)
                      : kSecondaryColor.withOpacity(opacityControl),
                  border: Border.all(color: kStrokeColor)),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding / 6),
                      child: Icon(
                        Icons.block,
                        color: cutSection ? kErrorColor : kPrimaryColor,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onDoubleTap: () {
              setMotorsDialog();
            },
            onVerticalDragUpdate: (details) {
              setState(() {
                opacityControl = 0.4;
                containerHeight -= details.delta.dy;
                if (containerHeight < minHeight) containerHeight = minHeight;
                if (containerHeight > maxHeight) containerHeight = maxHeight;
              });
            },
            onVerticalDragEnd: (details) {
              setState(() {
                opacityControl = 1;
                if (details.velocity.pixelsPerSecond.dy > 0) {
                  // Arrastando para baixo
                  if (containerHeight < maxHeight * 0.99) {
                    containerHeight = minHeight;
                    cutSection = false;
                    section['cutted'][widget.id - 1] = false;
                  } else {
                    containerHeight = maxHeight;
                    cutSection = true;
                    section['cutted'][widget.id - 1] = true;
                  }
                } else {
                  // Arrastando para cima
                  if (containerHeight > minHeight * 0.3) {
                    containerHeight = maxHeight;
                    cutSection = true;
                    section['cutted'][widget.id - 1] = true;
                  } else {
                    containerHeight = minHeight;
                    cutSection = false;
                    section['cutted'][widget.id - 1] = false;
                  }
                }
              });

              // Gera o offset para desligamento dos motores
              int offset = 0;
              for (int i = 0; i < widget.id - 1; i++) {
                offset += machine['sectionsLayout'][i] as int;
              }

              // Desliga os motores de braquiária correspondentes a seção selecionada
              int totalLayoutFertilizer = 0;
              for (var i = 0; i < fertilizer['layout'].length; i++) {
                totalLayoutFertilizer += fertilizer['layout'][i] as int;
                if ((totalLayoutFertilizer > offset + 1) &&
                    (totalLayoutFertilizer <=
                        machine['sectionsLayout'][widget.id - 1] + offset)) {
                  fertilizer['setMotors'][i] = cutSection ? 0 : 1;
                }
              }

              // Desliga os motores de adubo correspondentes a seção selecionada
              int totalLayoutBrachiaria = 0;
              for (var i = 0; i < brachiaria['layout'].length; i++) {
                totalLayoutBrachiaria += brachiaria['layout'][i] as int;
                if ((totalLayoutBrachiaria > offset + 1) &&
                    (totalLayoutBrachiaria <=
                        machine['sectionsLayout'][widget.id - 1] + offset)) {
                  brachiaria['setMotors'][i] = cutSection ? 0 : 1;
                }
              }

              // Desliga os motores de semente correspondentes a seção selecionada
              for (var i = 0;
                  i < machine['sectionsLayout'][widget.id - 1];
                  i++) {
                if (widget.id == 1) {
                  seed['setMotors'][i] = cutSection ? 0 : 1;
                } else {
                  seed['setMotors'][i + offset] = cutSection ? 0 : 1;
                }
              }
              soundManager.playSound('cut');
              Messages().message["setMotors"]!();
            },
            child: Container(
              width: ((widget.numberOfLines - 1) * Charts.getGroupSpace() +
                  widget.numberOfLines * 16),
              height: maxHeight,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
