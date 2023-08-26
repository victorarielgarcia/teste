
import 'package:flutter/material.dart';
import '../../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import '../utilities/global.dart';

class JMButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? icon;
  final bool lessButton;
  final bool moreButton;
  final bool disabled;
  const JMButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = kPrimaryColor,
    this.foregroundColor = kSecondaryColor,
    this.icon,
    this.lessButton = false,
    this.moreButton = false,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<JMButton> createState() => _JMButtonState();
}

class _JMButtonState extends State<JMButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: widget.moreButton
              ? const BorderRadius.only(
                  bottomRight: Radius.circular(kDefaultBorderSize),
                )
              : widget.lessButton
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(kDefaultBorderSize),
                    )
                  : BorderRadius.circular(kDefaultBorderSize),
        ),
        textStyle: (widget.moreButton || widget.lessButton)
            ? const TextStyle(
                color: kSecondaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w500)
            : const TextStyle(color: kSecondaryColor),
      ),
      onPressed: widget.disabled
          ? null
          : () {
              soundManager.playSound('click');
              widget.onPressed();
            },
      child: widget.icon ?? Text(widget.text),
    );
  }
}
