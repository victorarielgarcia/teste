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
    // refreshState();
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

  int adjustIndex(int i, int index, List<List<dynamic>> layout) {
    int adjustment = 0;
    int sum = 0;
    for (int j = 0; j < layout.length; j++) {
      sum += layout[j][2] as int;
      if (index <= sum) {
        break;
      }
      adjustment += 12 - (sum - (layout[j][2] as int));
    }
    return i + adjustment;
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 16,
    List<int> showTooltips = const [],
  }) {
    // if (((y < 100 - seed["secondErrorLimit"]) ||
    //         (y > 100 + seed["secondErrorLimit"])) &&
    //     status['isPlanting'] &&
    //     seed['setSensors'][x - 1] == 1 &&
    //     !machine['stoppedMotors']) {
    //   soundManager.playSound('beep');
    // }
    if (((y < 100 - seed["secondErrorLimit"])) &&
        status['isPlanting'] &&
        seed['setSensors'][x - 1] == 1 &&
        seed['setMotors'][x - 1] == 1 &&
        !machine['stoppedMotors']) {
      soundManager.playSound('beep');
    }
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
      minY: 50,
      maxY: 150,
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
            interval: 25,
            getTitlesWidget: (value, meta) {
              String title = "";
              switch (value) {
                case 50:
                  title = "-50 %";
                  break;
                case 75:
                  title = "-25 %";
                  break;
                case 100:
                  title = "    0 %";
                  break;
                case 125:
                  title = "+25 %";
                  break;
                case 150:
                  title = "+50 %";
                  break;
                default:
                  title = "e";
                  break;
              }

              return Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 10),
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
        int index = i + 1;

        // Lógica de ajuste de "i" com base no layout
        if (index <= (module['layout'][0][2] as int)) {
          // Sem alterações
        } else if (index <=
            (module['layout'][0][2] as int) + (module['layout'][1][2] as int)) {
          i += (12 - module['layout'][0][2] as int);
        } else if (index <=
            (module['layout'][0][2] as int) +
                (module['layout'][1][2] as int) +
                (module['layout'][2][2] as int)) {
          i += (12 - module['layout'][0][2] as int) +
              (24 - 12 - module['layout'][1][2] as int);
        } else if (index <=
            (module['layout'][0][2] as int) +
                (module['layout'][1][2] as int) +
                (module['layout'][2][2] as int) +
                (module['layout'][3][2] as int)) {
          i += (12 - module['layout'][0][2] as int) +
              (24 - 12 - module['layout'][1][2] as int) +
              (36 - 12 - module['layout'][2][2] as int);
        } else if (index <=
            (module['layout'][0][2] as int) +
                (module['layout'][1][2] as int) +
                (module['layout'][2][2] as int) +
                (module['layout'][3][2] as int) +
                (module['layout'][4][2] as int)) {
          i += (12 - module['layout'][0][2] as int) +
              (24 - 12 - module['layout'][1][2] as int) +
              (36 - 12 - module['layout'][2][2] as int) +
              (48 - 12 - module['layout'][2][2] as int);
        }
        // Se você tiver mais layouts, continue a lógica aqui.

        // Verificações básicas comuns a todos os cases
        bool isRateValid = index < seedState.rate.length;
        bool isSensorSet = seed['setSensors'][i] == 1;

        return makeGroupData(
            index,
            (isRateValid && isSensorSet)
                ? calculatePercentage(seedState.rate[i])
                : 0);
      }),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 24.9,
        checkToShowHorizontalLine: (value) => true,
        checkToShowVerticalLine: (value) => false,
      ),
    );
  }

  double calculatePercentage(double seedRate) {
    double seedPercentageOfRate = 0.0;
    seedPercentageOfRate = ((seedRate * 100) / seed['desiredRate']).toDouble();
    if (seedPercentageOfRate > 150) {
      seedPercentageOfRate = 150;
    } else if (seedPercentageOfRate < 0) {
      seedPercentageOfRate = 0;
    }
    return seedPercentageOfRate;
  }
}
