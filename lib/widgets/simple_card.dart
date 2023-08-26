import 'package:flutter/material.dart';

import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';

class SimpleCard extends StatelessWidget {
  final String title;
  final String text;
  final String unit;
  final double unitFontSize;
  final double titleFontSize;
  final double textFontSize;
  final double height;
  final double width;

  const SimpleCard({
    super.key,
    required this.title,
    required this.text,
    this.textFontSize = 34,
    this.unit = '',
    this.height = 118,
    this.width = 320,
    this.unitFontSize = 20,
    this.titleFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kStrokeColor),
          borderRadius: BorderRadius.circular(kDefaultBorderSize),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(top: kDefaultPadding / 2),
            child: Text(
              title,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w300,
                  fontSize: titleFontSize),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kDefaultPadding / 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: textFontSize),
                ),
                // const SizedBox(width: kDefaultPadding / 4),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  child: Text(
                    unit,
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: unitFontSize),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
