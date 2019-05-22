import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../../Database/expense_db.dart';
import '../../../Models/Analystic/categories.dart';
import '../../../Views/Analystics/Month/dummy_chart_data.dart';
import '../../../Views/Analystics/Month/categories_percentage.dart';

class AnalysticsMain extends StatefulWidget {
  @override
  _AnalysticsMainState createState() => _AnalysticsMainState();
}

class _AnalysticsMainState extends State<AnalysticsMain> {
  DateFormat _monthFormat = DateFormat("MMMM");
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  var series;
  DBProvider _dbProvider = DBProvider();
  List<Categories> catExpList = [];
  var loading = true;
  DateTime _selectedMonth = DateTime.now();
  bool noPieChart = false;
  var max = 0.0;
  var maxIncome = 0.0;

  @override
  void initState() {
    super.initState();
    _getCatExp();
  }

  _showMonthDialog() {
    showMonthPicker(context: context, initialDate: _selectedMonth).then((date) {
      if (date == null) {
        setState(() {
          _selectedMonth = _selectedMonth;
          loading = true;
        });
      } else {
        setState(() {
          _selectedMonth = date;
          loading = true;
        });
      }
      _getCatExp();
    });
  }

  _getCatExp() async {
    max = 0.0;
    await _dbProvider
        .getEachCatMonthExp(
      _selectedMonth.month.toString(),
      _selectedMonth.year.toString(),
    )
        .then((results) {
      catExpList = results;
    });
    for (var catExp in catExpList) {
      max += catExp.totalAmt;
    }
    if (max == 0.0) {
      setState(() {
        noPieChart = true;
        loading = false;
      });
      _createPieChart();
    } else {
      setState(() {
        noPieChart = false;
        loading = false;
      });
      _createPieChart();
    }
  }

  _createPieChart() {
    series = [
      new charts.Series(
        id: 'ExpenseByCat',
        domainFn: (Categories cate, _) => cate.catId,
        measureFn: (Categories cate, _) => cate.totalAmt,
        data: noPieChart == false ? catExpList : dummyList,
        labelAccessorFn: (Categories cate, _) => noPieChart == true
            ? null
            : cate.totalAmt == 0.0
                ? null
                : "\$ " +
                    cate.totalAmt.toString().replaceAllMapped(reg, mathFunc),
        colorFn: (Categories cate, _) => cate.color,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var dev = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: Color(0xFF31373F),
          appBar: AppBar(
            elevation: 0.0,
            title: Text("Analystics"),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: dev.longestSide - kToolbarHeight - 24.0 - 90.0,
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expense by Category",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: dev.longestSide > 600 ? 18.0 : 14.0),
                        ),
                        Container(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            onPressed: _showMonthDialog,
                            child: Text(
                              _monthFormat.format(_selectedMonth).toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      dev.longestSide > 600 ? 18.0 : 14.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(0.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    height: dev.longestSide / 3,
                    child: loading == false
                        ? Stack(
                            children: <Widget>[
                              noPieChart == true
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Not Available!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0),
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Total Expense",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                          Text(
                                            "\$ " +
                                                max.toString().replaceAllMapped(
                                                    reg, mathFunc),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                    ),
                              charts.PieChart(
                                series,
                                defaultRenderer: new charts.ArcRendererConfig(
                                  strokeWidthPx: 0.0,
                                  arcWidth: 15,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                      labelPadding: 5,
                                      outsideLabelStyleSpec:
                                          charts.TextStyleSpec(
                                              color:
                                                  charts.MaterialPalette.white,
                                              fontSize: 10),
                                      labelPosition:
                                          charts.ArcLabelPosition.auto,
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  Container(
                    color: Colors.black12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "INCOME",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 2),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 8.0),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.green,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 8.0, left: 8.0),
                                    child: FutureBuilder(
                                      future: _dbProvider.getMonthlyIncome(
                                          _selectedMonth.month.toString()),
                                      builder: (context, snapshot) {
                                        maxIncome = 0.0;
                                        if (snapshot.hasData &&
                                            snapshot.data.length != 0) {
                                          for (var item in snapshot.data) {
                                            maxIncome += item.amount;
                                          }
                                          return Text(
                                            "\$ " +
                                                maxIncome
                                                    .toString()
                                                    .replaceAllMapped(
                                                        reg, mathFunc),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0),
                                          );
                                        } else {
                                          return Text(
                                            "\$ 0.0",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 0.5,
                          height: 50.0,
                          color: Colors.white24,
                        ),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "EXPENSE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 2),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 8.0),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 8.0, left: 8.0),
                                    child: Text(
                                      "\$ " +
                                          max
                                              .toString()
                                              .replaceAllMapped(reg, mathFunc),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 0.5,
                          height: 50.0,
                          color: Colors.white24,
                        ),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "BALANCE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 2),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 8.0, left: 0.0),
                                    child: Text(
                                      "\$ " +
                                          (maxIncome - max)
                                              .toString()
                                              .replaceAllMapped(reg, mathFunc),
                                      style: TextStyle(
                                          color: (maxIncome - max) > 0.0
                                              ? Colors.green
                                              : (maxIncome - max) == 0.0
                                                  ? Colors.white
                                                  : Colors.redAccent,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PercentageCategories(
                    selectedMonth: _selectedMonth,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
