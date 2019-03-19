import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
// import '../../../Models/Analystic/categories.dart';

class WeekAnalystics extends StatefulWidget {
  @override
  _WeekAnalysticsState createState() => _WeekAnalysticsState();
}

class _WeekAnalysticsState extends State<WeekAnalystics> {
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");
  DateTime currentDate = DateTime.now();
  String startDate;
  String endDate;
  var series;
  @override
  void initState() {
    super.initState();
    setDate();
    _createChart();
  }

  var data = [
    new OrdinalSales('2014', 5),
    new OrdinalSales('2015', 25),
    new OrdinalSales('2016', 100),
    new OrdinalSales('2017', 75),
  ];

  _createChart() {
    series = [
      charts.Series<OrdinalSales, String>(
          id: 'Sales',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (OrdinalSales sales, _) =>
              '${sales.year}: \$${sales.sales.toString()}')
    ];
  }

  setDate() {
    if (currentDate.weekday == 7) {
      startDate = _dateFormat.format(currentDate);
      endDate = _dateFormat.format(currentDate.add(Duration(days: 6)));
    } else if (currentDate.weekday == 1) {
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 1)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 5)));
    } else if (currentDate.weekday == 2) {
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 2)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 4)));
    } else if (currentDate.weekday == 3) {
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 3)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 3)));
    } else if (currentDate.weekday == 4) {
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 4)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 2)));
    } else if (currentDate.weekday == 5) {
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 5)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 1)));
    } else {
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 6)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
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
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Text(
                    "From $startDate to $endDate",
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20.0),
                  ),
                ),
                Container(
                  width: device.longestSide / 2,
                  height: 300.0,
                  child: charts.BarChart(
                    series,
                    vertical: false,
                    barRendererDecorator:
                        new charts.BarLabelDecorator<String>(),
                    domainAxis: new charts.OrdinalAxisSpec(
                        renderSpec: new charts.NoneRenderSpec()),
                  ),
                ),
                Row(
                  children: <Widget>[Container()],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
