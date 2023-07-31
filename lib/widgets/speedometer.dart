import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utilities/constants/colors.dart';
import '../utilities/global.dart';

class Speedometer extends StatefulWidget {
  const Speedometer({
    super.key,
  });

  @override
  State<Speedometer> createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer> {
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
    if (velocity['options'] == 1) {
      speed = antenna['speed'];
      antennaManager.addListener(antennaListener);
    } else if (velocity['options'] == 2) {
      speed = nmea['speed'];
      nmeaManager.addListener(nmeaListener);
    } else if (velocity['options'] == 3) {
      speed = velocity['speed'].toDouble();
    }
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
    return Container(
      height: 180,
      width: 180,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(180),
          border: Border.all(color: kStrokeColor)),
      child: SfRadialGauge(
        axes: [
          RadialAxis(
              startAngle: 150,
              endAngle: 30,
              maximum: 20,
              showAxisLine: false,
              ticksPosition: ElementsPosition.outside,
              labelsPosition: ElementsPosition.outside,
              radiusFactor: 0.9,
              canRotateLabels: true,
              showLastLabel: true,
              majorTickStyle: const MajorTickStyle(
                color: kPrimaryColor,
                length: 0.08,
                lengthUnit: GaugeSizeUnit.factor,
              ),
              minorTickStyle: const MinorTickStyle(
                color: kPrimaryColor,
                length: 0.04,
                lengthUnit: GaugeSizeUnit.factor,
              ),
              minorTicksPerInterval: 5,
              interval: 2,
              axisLabelStyle: const GaugeTextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              pointers: [
                NeedlePointer(
                    enableAnimation: true,
                    value: speed,
                    tailStyle: const TailStyle(length: 0.2, width: 5),
                    needleEndWidth: 5,
                    needleLength: 0.7,
                    knobStyle: const KnobStyle())
              ],
              annotations: [
                GaugeAnnotation(
                    angle: 90,
                    positionFactor: 1.35,
                    widget: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          top: 0,
                          child: Text(
                              speed.toStringAsFixed(1).replaceAll('.', ','),
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Positioned(
                          top: 42,
                          child: Text('km/h',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    )),
              ],
              ranges: [
                GaugeRange(
                    startValue: 0,
                    endValue: 20,
                    startWidth: 0.02,
                    gradient: const SweepGradient(
                      colors: [
                        kSuccessColor,
                        kWarningColor,
                        kErrorColor,
                      ],
                      stops: [0.3, 0.5, 0.75],
                    ),
                    rangeOffset: 0.08,
                    endWidth: 0.12,
                    sizeUnit: GaugeSizeUnit.factor)
              ]),
        ],
      ),
    );
  }
}