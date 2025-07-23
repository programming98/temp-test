import 'package:flutter/material.dart';

class TemperatureUtils {
  static Color getColorByTemp(double temp) {
    if (temp > 90) {
      return Colors.redAccent;
    } else if (temp < 65) {
      return Colors.orange;
    } else if (temp < 40) {
      return Colors.blue;
    } else {
      return Colors.lightBlue;
    }
  }
}
