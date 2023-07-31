class CoordinateConverter {
  static double dmsToDecimal(
      int degrees, double minutes, String direction) {
    double decimal = degrees + (minutes / 60);
    if (direction == 'S' || direction == 'W') {
      decimal = decimal * -1;
    }
    return decimal;
  }
}
