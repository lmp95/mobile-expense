import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import '../../Models/Expense/expense.dart';
import '../../Views/LandingPage/today_expense.dart';
import '../../Database/expense_db.dart';
import '../../Views/ExpenseHistory/history.dart';
import 'dart:io';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  var dateFormat = DateFormat("dd MM yyyy");
  var chart;
  var series;
  var loading = false;
  var item;
  var price;

  @override
  void initState() {
    super.initState();
    DBProvider dbProvider = DBProvider();
    dbProvider.initDb();
    _charts();
  }

  _charts() {
    var data = [
      Expense(date: '24 Jan', amount: 12500),
      Expense(date: '25 Jan', amount: 5000),
      Expense(date: '26 Jan', amount: 2450),
      Expense(date: '27 Jan', amount: 10500),
      Expense(date: '28 Jan', amount: 4300),
      Expense(date: '29 Jan', amount: 2200),
      Expense(date: '30 Jan', amount: 12500),
    ];
    series = [
      charts.Series(
          domainFn: (Expense expense, _) => expense.date,
          measureFn: (Expense expense, _) => expense.amount,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          id: 'Expense',
          data: data)
    ];
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    var actualHeight = device.height - 24 - kToolbarHeight;
    return WillPopScope(
      onWillPop: () {exit(0);},
          child: OrientationBuilder(
        builder: (context, orientation) {
          return Theme(
            data: ThemeData(
              canvasColor: Colors.transparent,
              fontFamily: 'Play',
              primaryColor: Color(0xFF242424),
              primarySwatch: Colors.red,
            ),
                    child: Scaffold(
              backgroundColor: Color(0xFF242424),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Container(
                            color: Color(0xFF242424),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 48.0, left: 16.0),
                                  child: Text(
                                    "Weekly Expense",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: device.height <= 600 &&
                                              orientation == Orientation.portrait
                                          ? 16.0
                                          : 20.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  margin: EdgeInsets.only(
                                    left: 16.0,
                                    top: 16.0,
                                  ),
                                  width: 35.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.redAccent,
                                  ),
                                ),
                                SizedBox(
                                  height: orientation == Orientation.portrait
                                      ? actualHeight / 2.5
                                      : actualHeight / 1.2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 12.0),
                                    child: charts.BarChart(
                                      series,
                                      domainAxis: new charts.OrdinalAxisSpec(
                                          renderSpec:
                                              new charts.SmallTickRendererSpec(
                                                  labelStyle:
                                                      new charts.TextStyleSpec(
                                                          fontSize: device.height <=600 && orientation == Orientation.portrait ? 8 : 10,
                                                          color:
                                                              charts
                                                                  .MaterialPalette
                                                                  .gray
                                                                  .shadeDefault),
                                                  lineStyle:
                                                      new charts.LineStyleSpec(
                                                          color: charts
                                                              .MaterialPalette
                                                              .gray
                                                              .shadeDefault))),
                                      primaryMeasureAxis:
                                          new charts.NumericAxisSpec(
                                              renderSpec:
                                                  new charts.GridlineRendererSpec(
                                                      labelStyle:
                                                          new charts.TextStyleSpec(
                                                          fontSize: device.height <=600 && orientation == Orientation.portrait ? 8 : 10,
                                                              color: charts
                                                                  .MaterialPalette
                                                                  .gray
                                                                  .shadeDefault),
                                                      lineStyle:
                                                          new charts.LineStyleSpec(
                                                              color: charts
                                                                  .MaterialPalette
                                                                  .gray
                                                                  .shadeDefault))),
                                    ),
                                  ),
                                ),
                                TodayExpense(orientation: orientation, actualHeight: actualHeight,)
                              ],
                            ),
                          ),
                      childCount: 1,
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => History()
                  ));
                },
                child: Icon(Icons.history),
              ),
            ),
          );
        },
      ),
    );
  }
}
