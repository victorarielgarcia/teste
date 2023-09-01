import 'package:flutter/material.dart';
import '../utilities/constants/colors.dart';
import '../utilities/constants/sizes.dart';
import 'card.dart';

class MotorInfoCard extends StatefulWidget {
  final int index;
  final String name;
  final int error;
  final double value;

  const MotorInfoCard({
    super.key,
    required this.index,
    this.error = -1,
    required this.value,
    required this.name,
  });

  @override
  State<MotorInfoCard> createState() => _MotorInfoCardState();
}

class _MotorInfoCardState extends State<MotorInfoCard> {
  bool error = false;
  // Timer? timer;
  // @override
  // void initState() {
  //   if (widget.error > 0) {
  //     timer = Timer.periodic(const Duration(milliseconds: 350), (timer) {

  //       setState(() {
  //         error = !error;
  //       });
  //     });
  //   }

  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   if (widget.error > 0) {
  //     timer?.cancel();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // motorDialog(context, widget.index, widget.name);
        },
        child: Stack(
          children: [
            JMCard(
              animationDuration: 200,
              height: 95,
              width: 90,
              backgroundColor: widget.error == 2 && !error
                  ? kErrorColor
                  : widget.error == 1 && !error
                      ? kWarningColor
                      : (widget.error == 0 && !error)
                          // || error
                          ? kSuccessColor
                          : Colors.white,
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.index + 1}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:
                            widget.error == -1 || widget.error == 1 || error
                                ? kPrimaryColor
                                : kBackgroundColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.value.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 18,
                            color: widget.error == -1 ||
                                    widget.error == 1 ||
                                    error
                                ? kPrimaryColor
                                : kBackgroundColor),
                      ),
                      Text(
                        ' RPM',
                        style: TextStyle(
                            fontSize: 10,
                            color: widget.error == -1 ||
                                    widget.error == 1 ||
                                    error
                                ? kPrimaryColor
                                : kBackgroundColor),
                      ),
                    ],
                  ),
                ],
              )),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: kDefaultPadding / 4),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: ClipOval(
                    child: Material(
                      color: kPrimaryColor,
                      child: InkWell(
                        splashColor: kSecondaryColor,
                        onTap: () {
                          // motorDialog(context, widget.index, widget.name);
                        },
                        child: const SizedBox(
                            width: 35,
                            height: 35,
                            child: Icon(Icons.info_outline,
                                color: kSecondaryColor, size: 18)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
