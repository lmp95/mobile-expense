import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import '../../Models/Expense/expense.dart';
import '../../Views/LandingPage/today_expense.dart';
import '../../Database/expense_db.dart';
import 'dart:io';
import '../../Views/LandingPage/navigate_btns.dart';
import '../LandingPage/this_month_expense.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormat = DateFormat("dd MM yyyy");
  var last7dateFormat = DateFormat("yyyy-MM-dd");
  var displayDateFormat = DateFormat("dd MMM");
  var chart;
  var series;
  var loading = false;
  // var _chartLoading = true;
  var item;
  var price;
  List<Expense> totalAmtList = [];
  DBProvider dbProvider = DBProvider();
  List<String> dtList = [];
  List<String> setDateList = [];

  @override
  void initState() {
    super.initState();
    dbProvider.initDb();
    // _charts();
  }

  // _getLastSevenExpense() async {
  //   for (var i = 0; i < 7; i++) {
  //     var date =
  //         last7dateFormat.format(DateTime.now().subtract(Duration(days: i)));
  //     var setDate =
  //         displayDateFormat.format(DateTime.now().subtract(Duration(days: i)));
  //     await dbProvider.lastSevenDays(date).then((data) {
  //       var totalAmt = 0.0;
  //       for (var item in data) {
  //         if (date == item.date) {
  //           totalAmt += item.amount;
  //         }
  //       }
  //       var exp = Expense(
  //         amount: totalAmt,
  //         date: setDate,
  //       );
  //       totalAmtList.add(exp);
  //     });
  //   }
  // }

  // _charts() async {
  //   await _getLastSevenExpense();
  //   series = [
  //     charts.Series(
  //         domainFn: (Expense expense, _) => expense.date,
  //         measureFn: (Expense expense, _) => expense.amount,
  //         colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
  //         id: 'Expense',
  //         data: totalAmtList)
  //   ];
  //   setState(() {
  //     _chartLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    var actualHeight = device.height - 24 - kToolbarHeight;
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          return Theme(
            data: ThemeData(
              fontFamily: 'Play',
              primaryColor: Color(0xFF31373F),
              primarySwatch: Colors.red,
              canvasColor: Colors.transparent,
            ),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0.0,
                title: Text("Dashboard"),
              ),
              backgroundColor: Color(0xFF31373F),
              body: SingleChildScrollView(
                child: Container(
                  color: Color(0xFF31373F),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: EdgeInsets.only(top: 48.0, left: 16.0),
                      //   child: Text(
                      //     "Weekly Expense",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: device.height <= 600 &&
                      //               orientation == Orientation.portrait
                      //           ? 16.0
                      //           : 20.0,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   alignment: AlignmentDirectional.centerStart,
                      //   margin: EdgeInsets.only(
                      //     left: 16.0,
                      //     top: 16.0,
                      //   ),
                      //   width: 35.0,
                      //   height: 5.0,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5.0),
                      //     color: Colors.redAccent,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: orientation == Orientation.portrait
                      //       ? actualHeight / 2.5
                      //       : actualHeight / 1.2,
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 12.0, vertical: 12.0),
                      //     child: _chartLoading == true ? Center(
                      //       child: CircularProgressIndicator(),
                      //     ) : charts.BarChart(
                      //       series,
                      //       domainAxis: new charts.OrdinalAxisSpec(
                      //           renderSpec:
                      //               new charts.SmallTickRendererSpec(
                      //                   labelStyle:
                      //                       new charts.TextStyleSpec(
                      //                           fontSize: device.height <=600 && orientation == Orientation.portrait ? 8 : 10,
                      //                           color:
                      //                               charts
                      //                                   .MaterialPalette
                      //                                   .gray
                      //                                   .shadeDefault),
                      //                   lineStyle:
                      //                       new charts.LineStyleSpec(
                      //                           color: charts
                      //                               .MaterialPalette
                      //                               .gray
                      //                               .shadeDefault))),
                      //       primaryMeasureAxis:
                      //           new charts.NumericAxisSpec(
                      //               renderSpec:
                      //                   new charts.GridlineRendererSpec(
                      //                       labelStyle:
                      //                           new charts.TextStyleSpec(
                      //                           fontSize: device.height <=600 && orientation == Orientation.portrait ? 8 : 10,
                      //                               color: charts
                      //                                   .MaterialPalette
                      //                                   .gray
                      //                                   .shadeDefault),
                      //                       lineStyle:
                      //                           new charts.LineStyleSpec(
                      //                               color: charts
                      //                                   .MaterialPalette
                      //                                   .gray
                      //                                   .shadeDefault))),
                      //     ),
                      //   ),
                      // ),
                      TodayExpense(
                        orientation: orientation,
                        actualHeight: actualHeight,
                      ),
                      NavigateBtn(
                        orientation: orientation,
                        actualHeight: actualHeight,
                      ),
                      ThisMonthExpense(),
                    ],
                  ),
                ),
              ),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (BuildContext context) => History(
              //               initialDate: DateTime.now(),
              //             ),
              //       ),
              //     );
              //   },
              //   child: Icon(Icons.history),
              // ),
            ),
          );
        },
      ),
    );
  }
}
