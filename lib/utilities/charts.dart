import 'global.dart';

class Charts {
  static double getGroupSpace() {
    double divider = 1;
    if (machine["numberOfLines"] < 20) {
      divider = 1.15;
    } else if (machine["numberOfLines"] < 15) {
      divider = 1.5;
    }
    double space =
        ((1160 - (machine["numberOfLines"] * 16)) / machine["numberOfLines"]) /
            divider;
    return space;
  }
}
