import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Annual {
  final String category;
  final String month;
  final String year;
  final double totalAmt;
  final charts.Color color;
  Annual({this.category, this.month, this.year, this.totalAmt, Color color})
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
