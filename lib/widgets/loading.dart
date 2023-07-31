import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: kPrimaryColor.withOpacity(0.7),
        child: const JMLoading());
  }
}

class JMLoading extends StatelessWidget {
  const JMLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.fallingDot(
      color: Colors.brown,

      // secondRingColor: kPrimaryColor,
      // thirdRingColor: kSecondaryColor,
      size: 80,
    ));
  }
}
