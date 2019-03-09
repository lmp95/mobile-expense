import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AnnualCategory {
  final int category;
  final String year;
  final double totalAmt;
  final charts.Color color;
  AnnualCategory({this.category, this.year, this.totalAmt, Color color})
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
