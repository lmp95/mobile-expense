import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnnualChart extends StatefulWidget {
  final chart;
  final pieChart;
  final annualTotal;
  AnnualChart({this.chart, this.pieChart, this.annualTotal});
  @override
  _AnnualChartState createState() => _AnnualChartState(
      chart: chart, pieChart: pieChart, annualTotal: annualTotal);
}

class _AnnualChartState extends State<AnnualChart> {
  final chart;
  final pieChart;
  final annualTotal;
  _AnnualChartState({this.chart, this.pieChart, this.annualTotal});

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(16.0),
      height: device.longestSide / 3,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: pieChart == false
                ? Text(
                    "No data available!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          "Total Expense".toUpperCase(),
                          style: TextStyle(
                            letterSpacing: 2,
                            color: Colors.redAccent,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Text(
                        "\$ " +
                            annualTotal
                                .toString()
                                .replaceAllMapped(reg, mathFunc),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
          ),
          charts.PieChart(
            chart,
            defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 15,
              strokeWidthPx: 0.0,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.outside,
                  labelPadding: 5,
                  outsideLabelStyleSpec: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
