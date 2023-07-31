import 'package:flutter/material.dart';

import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';

class AdjustCard extends StatefulWidget {
  final String title;
  final String unit;
  final String buttonText;
  final int id;

  final Function() onTap;
  const AdjustCard({
    super.key,
    required this.title,
    required this.unit,
    required this.id,
    required this.onTap,
    required this.buttonText,
  });

  @override
  State<AdjustCard> createState() => _AdjustCardState();
}

class _AdjustCardState extends State<AdjustCard> {
  String variable = '';

  @override
  void initState() {
    _setInitValue();
    super.initState();
  }

  _setInitValue() {
    dynamic tempValue;
    switch (widget.id) {
      case 1:
        tempValue = fertilizer['constantWeight'];
        break;
      case 2:
        tempValue = brachiaria['constantWeight'];
        break;
      case 3:
        tempValue = machine['numberOfLines'];
        break;
      case 4:
        tempValue = machine['sectionsLayout'].length;
        break;
      case 5:
        tempValue = calibration['calibrationResult'];
        break;
    }
    setState(() {
      variable = tempValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        soundManager.playSound('click');
        widget.onTap();
      },
      child: Padding(
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
                    padding:
                        const EdgeInsets.fromLTRB(0, kDefaultPadding / 2, 0, 0),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        variable,
                        style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 34),
                      ),
                      const SizedBox(width: kDefaultPadding / 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          widget.unit,
                          style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 318,
                        height: 50,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            border: Border.all(color: kStrokeColor),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(kDefaultBorderSize),
                              bottomRight: Radius.circular(kDefaultBorderSize),
                            )),
                        child: Center(
                            child: Text(
                          widget.buttonText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
