import 'package:easytech_electric_blue/utilities/global.dart';

class Speed {
  static double getCurrentVelocity() {
    double speed = 0.0;
    if (velocity['options'] == 1) {
      speed = antenna['speed'];
    } else if (velocity['options'] == 2) {
      speed = nmea['speed'];
    } else if (velocity['options'] == 3) {
      speed = velocity['speed'].toDouble();
    }
    return speed;
  }
}
