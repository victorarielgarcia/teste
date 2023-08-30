import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utilities/constants/colors.dart';
import '../../utilities/constants/sizes.dart';

class QualityChart extends StatelessWidget {
  const QualityChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              kDefaultPadding, kDefaultPadding, kDefaultPadding / 2, 0),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // const Text(
              //   "90%",
              //   style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      enabled: true,
                    ),
                    centerSpaceRadius: 35,
                    sections: [
                      PieChartSectionData(
                        color: kSuccessColor,
                        value: 0,
                        radius: 20,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: kSecondaryColor,
                        radius: 20,
                        showTitle: false,
                      ),
                    ],
                  ),
                  swapAnimationDuration: const Duration(seconds: 1),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
            ],
          ),
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("0% singulação"),
            Text("0% falhas"),
            Text("0% duplas"),
          ],
        ),
      ],
    );
  }
}
