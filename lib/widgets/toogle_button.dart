import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';

class ToogleButton extends StatefulWidget {
  final int id;
  final String firstText;
  final String secoundText;
  final IconData firstIcon;
  final IconData secoundIcon;
  final bool icon;
  final bool rotate;

  const ToogleButton({
    super.key,
    required this.id,
    this.icon = false,
    this.firstText = '',
    this.secoundText = '',
    this.firstIcon = Icons.abc,
    this.secoundIcon = Icons.abc,
    this.rotate = false,
  });

  @override
  State<ToogleButton> createState() => _ToogleButtonState();
}

class _ToogleButtonState extends State<ToogleButton> {
  bool variable = false;

  @override
  void initState() {
    _setInitValue();
    super.initState();
  }

  _setInitValue() {
    bool tempValue = false;
    switch (widget.id) {
      case 1:
        tempValue = advancedSettings['motor50RPMSeed'];
        break;
      case 2:
        tempValue = advancedSettings['anticlockwiseSeed'];
        break;
      case 3:
        tempValue = advancedSettings['motor50RPMFertilizer'];
        break;
      case 4:
        tempValue = advancedSettings['anticlockwiseFertilizer'];
        break;
      case 5:
        tempValue = advancedSettings['motor50RPMBrachiaria'];
        break;
      case 6:
        tempValue = advancedSettings['anticlockwiseBrachiaria'];
        break;
    }
    setState(() {
      variable = tempValue;
    });
  }

  _setValues() {
    switch (widget.id) {
      case 1:
        setState(() {
          advancedSettings['motor50RPMSeed'] = variable;
        });
        break;
      case 2:
        setState(() {
          advancedSettings['anticlockwiseSeed'] = variable;
        });
        break;
      case 3:
        setState(() {
          advancedSettings['motor50RPMFertilizer'] = variable;
        });
        break;
      case 4:
        setState(() {
          advancedSettings['anticlockwiseFertilizer'] = variable;
        });
        break;
      case 5:
        setState(() {
          advancedSettings['motor50RPMBrachiaria'] = variable;
        });
        break;
      case 6:
        setState(() {
          advancedSettings['anticlockwiseBrachiaria'] = variable;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              variable = !variable;
              _setValues();
            });
          },
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                color: variable ? Colors.white : kPrimaryColor,
                border: Border.all(color: kStrokeColor),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(kDefaultBorderSize),
                  topLeft: Radius.circular(kDefaultBorderSize),
                )),
            child: Center(
                child: widget.icon
                    ? widget.rotate
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Icon(
                              widget.firstIcon,
                              color: variable ? kPrimaryColor : Colors.white,
                            ))
                        : Icon(
                            widget.firstIcon,
                            color: variable ? kPrimaryColor : Colors.white,
                          )
                    : Text(
                        widget.firstText,
                        style: TextStyle(
                            color: variable ? kPrimaryColor : Colors.white,
                            fontWeight: FontWeight.w500),
                      )),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              variable = !variable;
            });
            _setValues();
          },
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: variable ? kPrimaryColor : Colors.white,
              border: Border.all(color: kStrokeColor),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(kDefaultBorderSize),
                  bottomRight: Radius.circular(kDefaultBorderSize)),
            ),
            child: Center(
                child: widget.icon
                    ? Icon(
                        widget.secoundIcon,
                        color: variable ? Colors.white : kPrimaryColor,
                      )
                    : Text(
                        widget.secoundText,
                        style: TextStyle(
                            color: variable ? Colors.white : kPrimaryColor,
                            // fontSize: 28,
                            fontWeight: FontWeight.w500),
                      )),
          ),
        ),
      ],
    );
  }
}
