import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Categories {
  final int catId;
  final String year;
  final String month;
  final double totalAmt;
  final charts.Color color;
  Categories({this.catId, this.year, this.month, this.totalAmt, Color color})
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
