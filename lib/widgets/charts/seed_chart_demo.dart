import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utilities/charts.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/sizes.dart';
import '../../utilities/global.dart';

class SeedChart extends StatefulWidget {
  const SeedChart({super.key});
  @override
  State<StatefulWidget> createState() => SeedChartState();
}

class SeedChartState extends State<SeedChart> {
  final Duration animDuration = const Duration(milliseconds: 500);
  int touchedIndex = -1;
  bool isPlaying = true;

  final seedState = seedManager.state;
  void seedListener() {
    if (mounted) {
      setState(() {
        seedState.rate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    seedManager.addListener(seedListener);

    // ANIMATION TESTE
    refreshState();
  }

  @override
  void dispose() {
    seedManager.removeListener(seedListener);
    isPlaying = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: BarChart(
                    getData(),
                    swapAnimationDuration: animDuration,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 16,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          borderRadius: BorderRadius.circular(kDefaultBorderSize),
          toY: y,
          color: (y >= 100 - seed["firstErrorLimit"] &&
                  y <= 100 + seed["firstErrorLimit"])
              ? kSuccessColor
              : (y >= 100 - seed["secondErrorLimit"] &&
                          y < 100 - seed["firstErrorLimit"]) ||
                      (y > 100 + seed["firstErrorLimit"] &&
                          y <= 100 + seed["secondErrorLimit"])
                  ? kWarningColor
                  : kErrorColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 200,
            color: Colors.transparent,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
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
      });

  BarChartData getData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white,
            tooltipBorder: const BorderSide(color: kStrokeColor, width: 1)),
        enabled: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 50,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  "${value.toInt()} %",
                  style: const TextStyle(fontSize: 11),
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
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
      barGroups: List.generate(machine["numberOfLines"], (i) {
        // switch (i + 1) {
        //   case 1:
        //     return makeGroupData(
        //         1,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 2:
        //     return makeGroupData(
        //         2,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 3:
        //     return makeGroupData(
        //         3,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 4:
        //     return makeGroupData(
        //         4,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 5:
        //     return makeGroupData(
        //         5,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 6:
        //     return makeGroupData(
        //         6,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 7:
        //     return makeGroupData(
        //         7,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 8:
        //     return makeGroupData(
        //         8,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 9:
        //     return makeGroupData(
        //         9,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 10:
        //     return makeGroupData(
        //         10,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 11:
        //     return makeGroupData(
        //         11,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 12:
        //     return makeGroupData(
        //         12,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 13:
        //     return makeGroupData(
        //         13,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 14:
        //     return makeGroupData(
        //         14,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 15:
        //     return makeGroupData(
        //         15,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 16:
        //     return makeGroupData(
        //         16,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 17:
        //     return makeGroupData(
        //         17,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 18:
        //     return makeGroupData(
        //         18,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 19:
        //     return makeGroupData(
        //         19,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 20:
        //     return makeGroupData(
        //         20,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 21:
        //     return makeGroupData(
        //         21,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 22:
        //     return makeGroupData(
        //         22,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 23:
        //     return makeGroupData(
        //         23,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 24:
        //     return makeGroupData(
        //         24,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 25:
        //     return makeGroupData(
        //         25,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 26:
        //     return makeGroupData(
        //         26,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 27:
        //     return makeGroupData(
        //         27,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 28:
        //     return makeGroupData(
        //         28,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 29:
        //     return makeGroupData(
        //         29,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 30:
        //     return makeGroupData(
        //         30,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 31:
        //     return makeGroupData(
        //         31,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 32:
        //     return makeGroupData(
        //         32,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 33:
        //     return makeGroupData(
        //         33,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 34:
        //     return makeGroupData(
        //         34,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 35:
        //     return makeGroupData(
        //         35,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 36:
        //     return makeGroupData(
        //         36,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 37:
        //     return makeGroupData(
        //         37,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 38:
        //     return makeGroupData(
        //         38,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 39:
        //     return makeGroupData(
        //         39,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 40:
        //     return makeGroupData(
        //         40,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 41:
        //     return makeGroupData(
        //         41,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 42:
        //     return makeGroupData(
        //         42,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 43:
        //     return makeGroupData(
        //         43,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 44:
        //     return makeGroupData(
        //         44,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 45:
        //     return makeGroupData(
        //         45,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 46:
        //     return makeGroupData(
        //         46,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 47:
        //     return makeGroupData(
        //         47,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 48:
        //     return makeGroupData(
        //         48,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 49:
        //     return makeGroupData(
        //         49,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 50:
        //     return makeGroupData(
        //         50,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 51:
        //     return makeGroupData(
        //         51,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 52:
        //     return makeGroupData(
        //         52,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 53:
        //     return makeGroupData(
        //         53,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 54:
        //     return makeGroupData(
        //         54,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 55:
        //     return makeGroupData(
        //         55,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 56:
        //     return makeGroupData(
        //         56,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 57:
        //     return makeGroupData(
        //         57,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 58:
        //     return makeGroupData(
        //         58,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 59:
        //     return makeGroupData(
        //         59,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   case 60:
        //     return makeGroupData(
        //         60,
        //         (i + 1) < seedState.rate.length
        //             ? calculatePercentage(seedState.rate[i])
        //             : 0);
        //   default:
        //     return throw Error();
        // }
        // Animation Simulation
        switch (i + 1) {
          case 1:
            return makeGroupData(
              1,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 2:
            return makeGroupData(
              2,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 3:
            return makeGroupData(
              3,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 4:
            return makeGroupData(
              4,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 5:
            return makeGroupData(
              5,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 6:
            return makeGroupData(
              6,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 7:
            return makeGroupData(
              7,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 8:
            return makeGroupData(
              8,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 9:
            return makeGroupData(
              9,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 10:
            return makeGroupData(
              10,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 11:
            return makeGroupData(
              11,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 12:
            return makeGroupData(
              12,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 13:
            return makeGroupData(
              13,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 14:
            return makeGroupData(
              14,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 15:
            return makeGroupData(
              15,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 16:
            return makeGroupData(
              16,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 17:
            return makeGroupData(
              17,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 18:
            return makeGroupData(
              18,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 19:
            return makeGroupData(
              19,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 20:
            return makeGroupData(
              20,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 21:
            return makeGroupData(
              21,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 22:
            return makeGroupData(
              22,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 23:
            return makeGroupData(
              23,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 24:
            return makeGroupData(
              24,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 25:
            return makeGroupData(
              25,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 26:
            return makeGroupData(
              26,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 27:
            return makeGroupData(
              27,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 28:
            return makeGroupData(
              28,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 29:
            return makeGroupData(
              29,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 30:
            return makeGroupData(
              30,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 31:
            return makeGroupData(
              31,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 32:
            return makeGroupData(
              32,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 33:
            return makeGroupData(
              33,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 34:
            return makeGroupData(
              34,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 35:
            return makeGroupData(
              35,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 36:
            return makeGroupData(
              36,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 37:
            return makeGroupData(
              37,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 38:
            return makeGroupData(
              38,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 39:
            return makeGroupData(
              39,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 40:
            return makeGroupData(
              40,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 41:
            return makeGroupData(
              41,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 42:
            return makeGroupData(
              42,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 43:
            return makeGroupData(
              43,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 44:
            return makeGroupData(
              44,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 45:
            return makeGroupData(
              45,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 46:
            return makeGroupData(
              46,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 47:
            return makeGroupData(
              47,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 48:
            return makeGroupData(
              48,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 49:
            return makeGroupData(
              49,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 50:
            return makeGroupData(
              50,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 51:
            return makeGroupData(
              51,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 52:
            return makeGroupData(
              52,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 53:
            return makeGroupData(
              53,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 54:
            return makeGroupData(
              54,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 55:
            return makeGroupData(
              55,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 56:
            return makeGroupData(
              56,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 57:
            return makeGroupData(
              57,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 58:
            return makeGroupData(
              58,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 59:
            return makeGroupData(
              59,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          case 60:
            return makeGroupData(
              60,
              seed['setMotors'][i] == 0 || machine['stoppedMotors']
                  ? 0
                  : Random().nextInt(6).toDouble() + 100,
            );
          default:
            return throw Error();
        }
      }),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 49,
        checkToShowHorizontalLine: (value) => true,
        checkToShowVerticalLine: (value) => false,
      ),
    );
  }

  double calculatePercentage(double seedRate) {
    double seedPercentageOfRate = 0.0;
    seedPercentageOfRate = ((seedRate * 100) / seed['desiredRate']).toDouble();
    if (seedPercentageOfRate > 200) {
      seedPercentageOfRate = 200;
    } else if (seedPercentageOfRate < 0) {
      seedPercentageOfRate = 0;
    }
    return seedPercentageOfRate;
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 10),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
