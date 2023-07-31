import 'package:flutter/material.dart';

import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';

class JMCard extends StatelessWidget {
  final double height;
  final double width;
  final Widget body;
  final Color backgroundColor;
  final int animationDuration;
  const JMCard({
    super.key,
    required this.height,
    required this.width,
    required this.body,
    this.backgroundColor = Colors.white,
    this.animationDuration = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: kStrokeColor),
          borderRadius: BorderRadius.circular(kDefaultBorderSize),
        ),
        duration: Duration(milliseconds: animationDuration),
        child: body);
  }
}
