import 'package:easytech_electric_blue/services/speed.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';

class SpeedometerV2 extends StatefulWidget {
  const SpeedometerV2({
    super.key,
  });

  @override
  State<SpeedometerV2> createState() => _SpeedometerV2State();
}

class _SpeedometerV2State extends State<SpeedometerV2> {
  final nmeaState = nmeaManager.state;
  void nmeaListener() {
    if (mounted) {
      setState(() {
        speed = nmeaState.satelliteSpeed;
      });
    }
  }

  final antennaState = antennaManager.state;
  void antennaListener() {
    if (mounted) {
      setState(() {
        speed = antennaState.speed;
      });
    }
  }

  double speed = 0.0;

  @override
  void initState() {
    speed = Speed.getCurrentVelocity();
    super.initState();
  }

  @override
  void dispose() {
    antennaManager.removeListener(antennaListener);
    nmeaManager.removeListener(nmeaListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: 160,
      child: Center(
          child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 1200,
        axes: <RadialAxis>[
          RadialAxis(
              showLabels: false,
              maximum: 20,
              axisLabelStyle: const GaugeTextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400),
              endAngle: 4,
              pointers: <GaugePointer>[
                RangePointer(
                  value: speed,
                  width: 0.2,
                  pointerOffset: -0.04,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: kBackgroundColor.withOpacity(0.8),
                  cornerStyle: CornerStyle.bothCurve,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    // axisValue: 50,

                    // positionFactor: 0.4,
                    widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      speed.toStringAsFixed(1).replaceAll('.', ','),
                      style: TextStyle(
                          color: kBackgroundColor.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                          fontSize: 38),
                    ),
                    Text(
                      'km/h',
                      style: TextStyle(
                          color: kBackgroundColor.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ))
              ]),
        ],
      )),
    );
  }
}
