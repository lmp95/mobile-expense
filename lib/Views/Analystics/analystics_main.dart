import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalysticsMain extends StatefulWidget {
  @override
  _AnalysticsMainState createState() => _AnalysticsMainState();
}

class _AnalysticsMainState extends State<AnalysticsMain> {
  DateFormat _monthFormat = DateFormat("MMMM");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      new LinearSales(0, 85, Colors.redAccent),
      new LinearSales(1, 75, Colors.greenAccent),
      new LinearSales(2, 25, Colors.purpleAccent),
      new LinearSales(3, 5, Colors.orangeAccent),
    ];
    var series = [
      new charts.Series(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (LinearSales row, _) => '5000',
        colorFn: (LinearSales sales, _) => sales.color,
      )
    ];
    var chart = charts.PieChart(
      series,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPadding: 5,
            outsideLabelStyleSpec: charts.TextStyleSpec(
                color: charts.MaterialPalette.white, fontSize: 14),
            labelPosition: charts.ArcLabelPosition.auto,
          )
        ],
      ),
    );
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: Color(0xFF31373F),
          appBar: AppBar(
            elevation: 0.0,
            title: Text("Analystics"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Month",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.green,
                        ),
                        child: Text(
                          _monthFormat.format(DateTime.now()).toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.longestSide / 2.5,
                  child: chart,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class LinearSales {
  final int year;
  final int sales;
  final charts.Color color;
  LinearSales(this.year, this.sales, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
