import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../Database/expense_db.dart';
import '../../Models/Analystic/categories.dart';
import '../../Views/Analystics/dummy_chart_data.dart';
import '../../Views/Analystics/generate_cate_monthly_exp_list.dart';
import '../../Views/Analystics/categories_percentage.dart';

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
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Monthly by Categories",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: dev.longestSide > 600 ? 20.0 : 16.0),
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
                                fontSize: dev.longestSide > 600 ? 18.0 : 14.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
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
                                          color: Colors.white, fontSize: 18.0),
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
                                    outsideLabelStyleSpec: charts.TextStyleSpec(
                                        color: charts.MaterialPalette.white,
                                        fontSize: 10),
                                    labelPosition: charts.ArcLabelPosition.auto,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: dev.width / 2 - 32.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  generateReport(_selectedMonth, 'Clothing',
                                      context, Color(0xFFFE5F55));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Color(0xFFFE5F55),
                                      ),
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Clothing",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: dev.width / 2 - 32.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  generateReport(
                                      _selectedMonth,
                                      'Entertainment',
                                      context,
                                      Color(0xFF52D1DC));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Color(0xFF52D1DC),
                                      ),
                                    ),
                                    Text(
                                      "Entertainment",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: dev.width / 2 - 32.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  generateReport(_selectedMonth, 'Food',
                                      context, Color(0xFF8661C1));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Color(0xFF8661C1),
                                      ),
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Food",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: dev.width / 2 - 32.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  generateReport(
                                      _selectedMonth,
                                      'Gifts/Donations',
                                      context,
                                      Color(0xFF7097A8));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Color(0xFF7097A8),
                                      ),
                                    ),
                                    Text(
                                      "Gifts/Donations",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: dev.width / 2 - 32.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  generateReport(
                                      _selectedMonth,
                                      'Medical/Healthcare',
                                      context,
                                      Color(0xFF1EA896));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Color(0xFF1EA896),
                                      ),
                                    ),
                                    Text(
                                      "Medical/Healthcare",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: dev.width / 2 - 32.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  generateReport(_selectedMonth, 'Personal',
                                      context, Color(0xFFF5853F));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Color(0xFFF5853F),
                                      ),
                                    ),
                                    Text(
                                      "Personal",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: dev.width / 2 - 32.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  generateReport(
                                      _selectedMonth,
                                      'Transportation',
                                      context,
                                      Color(0xFFFFE787));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Color(0xFFFFE787),
                                      ),
                                    ),
                                    Text(
                                      "Transportation",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: dev.width / 2 - 32.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  generateReport(_selectedMonth, 'Utilities',
                                      context, Color(0xFF19647E));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Color(0xFF19647E),
                                      ),
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Utilities",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PercentageCategories()
              ],
            ),
          ),
        );
      },
    );
  }
}
