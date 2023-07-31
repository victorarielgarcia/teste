
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utilities/charts.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/sizes.dart';
import '../../utilities/global.dart';

class BrachiariaChart extends StatefulWidget {
  const BrachiariaChart({super.key});
  @override
  State<StatefulWidget> createState() => BrachiariaChartState();
}

class BrachiariaChartState extends State<BrachiariaChart> {
  final motorState = motorManager.state;
  void motorListener() {
    if (mounted) {
      setState(() {
        motorState.rpm;
      });
    }
  }

  @override
  void initState() {
    motorManager.addListener(motorListener);
    super.initState();
  }

  @override
  void dispose() {
    motorManager.removeListener(motorListener);
    super.dispose();
  }

  final Duration animDuration = const Duration(milliseconds: 300);
  int touchedIndex = -1;
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kDefaultPadding * 3,
          kDefaultPadding / 2, kDefaultPadding, kDefaultPadding / 2),
      // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: kDefaultPadding*2),
      child: BarChart(
        randomData(),
        swapAnimationDuration: animDuration,
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 60,
    List<int> showTooltips = const [],
  }) {
    double rpmCurrent =
        motorState.rpm[brachiaria['addressedLayout'][x - 1] - 1];
    double rpmTarget = motorState.targetRPMBrachiaria;
    int error = 0;
    if (rpmCurrent == 0) {
      error = -1;
    } else {
      double percentageDifference =
          ((rpmCurrent - rpmTarget).abs() / rpmTarget) * 100;

      if (percentageDifference >= 5 && percentageDifference < 10) {
        error = 0;
      } else if (percentageDifference >= 10 && percentageDifference < 15) {
        error = 1;
      } else if (percentageDifference >= 15) {
        error = 2;
      }
    }
    // else if (percentageDifference >= 20) {
    //   error = 3;
    // }
    double speed = 0.0;
    if (velocity['options'] == 1) {
      speed = antenna['speed'];
    } else if (velocity['options'] == 2) {
      speed = nmea['speed'];
    } else if (velocity['options'] == 3) {
      speed = velocity['speed'].toDouble();
    }
    if (speed == 0 && rpmCurrent < 1) {
      error = -1;
    }
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          borderRadius: BorderRadius.circular(6),
          toY: y,
          color: error == 2
              ? kErrorColor
              : error == 1
                  ? kWarningColor
                  : error == 0
                      ? kSuccessColor
                      : kSecondaryColor,
          width: brachiaria["layout"][x - 1] == 1
              ? 16
              : 16 * brachiaria["layout"][x - 1] +
                  Charts.getGroupSpace() * (brachiaria["layout"][x - 1] - 1),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(
        7,
        (i) {
          switch (i) {
            case 0:
              return makeGroupData(0, 5, isTouched: i == touchedIndex);
            case 1:
              return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
            case 2:
              return makeGroupData(2, 5, isTouched: i == touchedIndex);
            case 3:
              return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
            case 4:
              return makeGroupData(4, 9, isTouched: i == touchedIndex);
            case 5:
              return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
            case 6:
              return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
            default:
              return throw Error();
          }
        },
      );

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: const FlTitlesData(
        show: false,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: kDefaultPadding / 2,
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      groupsSpace: Charts.getGroupSpace(),
      alignment: BarChartAlignment.center,
      barGroups: List.generate(brachiaria["layout"].length, (i) {
        switch (i + 1) {
          case 1:
            return makeGroupData(1, 1);
          case 2:
            return makeGroupData(2, 1);
          case 3:
            return makeGroupData(3, 1);
          case 4:
            return makeGroupData(4, 1);
          case 5:
            return makeGroupData(5, 1);
          case 6:
            return makeGroupData(6, 1);
          case 7:
            return makeGroupData(7, 1);
          case 8:
            return makeGroupData(8, 1);
          case 9:
            return makeGroupData(9, 1);
          case 10:
            return makeGroupData(10, 1);
          case 11:
            return makeGroupData(11, 1);
          case 12:
            return makeGroupData(12, 1);
          case 13:
            return makeGroupData(13, 1);
          case 14:
            return makeGroupData(14, 1);
          case 15:
            return makeGroupData(15, 1);
          case 16:
            return makeGroupData(16, 1);
          case 17:
            return makeGroupData(17, 1);
          case 18:
            return makeGroupData(18, 1);
          case 19:
            return makeGroupData(19, 1);
          case 20:
            return makeGroupData(20, 1);
          case 21:
            return makeGroupData(21, 1);
          case 22:
            return makeGroupData(22, 1);
          case 23:
            return makeGroupData(23, 1);
          case 24:
            return makeGroupData(24, 1);
          case 25:
            return makeGroupData(25, 1);
          case 26:
            return makeGroupData(26, 1);
          case 27:
            return makeGroupData(27, 1);
          case 28:
            return makeGroupData(28, 1);
          case 29:
            return makeGroupData(29, 1);
          case 30:
            return makeGroupData(30, 1);
          case 31:
            return makeGroupData(31, 1);
          case 32:
            return makeGroupData(32, 1);
          case 33:
            return makeGroupData(33, 1);
          case 34:
            return makeGroupData(34, 1);
          case 35:
            return makeGroupData(35, 1);
          case 36:
            return makeGroupData(36, 1);
          case 37:
            return makeGroupData(37, 1);
          case 38:
            return makeGroupData(38, 1);
          case 39:
            return makeGroupData(39, 1);
          case 40:
            return makeGroupData(40, 1);
          case 41:
            return makeGroupData(41, 1);
          case 42:
            return makeGroupData(42, 1);
          case 43:
            return makeGroupData(43, 1);
          case 44:
            return makeGroupData(44, 1);
          case 45:
            return makeGroupData(45, 1);
          case 46:
            return makeGroupData(46, 1);
          case 47:
            return makeGroupData(47, 1);
          case 48:
            return makeGroupData(48, 1);
          case 49:
            return makeGroupData(49, 1);
          case 50:
            return makeGroupData(50, 1);
          case 51:
            return makeGroupData(51, 1);
          case 52:
            return makeGroupData(52, 1);
          case 53:
            return makeGroupData(53, 1);
          case 54:
            return makeGroupData(54, 1);
          case 55:
            return makeGroupData(55, 1);
          case 56:
            return makeGroupData(56, 1);
          case 57:
            return makeGroupData(57, 1);
          case 58:
            return makeGroupData(58, 1);
          case 59:
            return makeGroupData(59, 1);
          case 60:
            return makeGroupData(60, 1);
          default:
            return throw Error();
        }
      }),
      gridData: FlGridData(
        show: false,
        checkToShowHorizontalLine: (value) => false,
        checkToShowVerticalLine: (value) => false,
      ),
    );
  }
}
