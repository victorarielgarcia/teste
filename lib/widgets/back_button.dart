import 'package:flutter/material.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';

class JMBackButton extends StatelessWidget {
  final Function() onPressed;
  const JMBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: kDefaultPadding,
      child: GestureDetector(
        onTap: onPressed,
        child: const SizedBox(
          width: 150,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              children: [
                Icon(Icons.arrow_back),
                SizedBox(width: kDefaultPadding / 2),
                Text(
                  "Voltar",
                  style: TextStyle(
                      fontSize: 22,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
