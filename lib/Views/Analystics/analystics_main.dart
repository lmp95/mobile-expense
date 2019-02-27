import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../Database/expense_db.dart';
import '../../Models/Analystic/categories.dart';

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

  @override
  void initState() {
    super.initState();
    _getCatExp();
  }

  _generateReport(String category) {
    print(category);
  }

  _showMonthDialog() {
    showMonthPicker(context: context, initialDate: DateTime.now())
        .then((date) {});
  }

  _getCatExp() async {
    await _dbProvider
        .getEachCatMonthExp(
      DateTime.now().month.toString(),
      DateTime.now().year.toString(),
    )
        .then((results) {
      catExpList = results;
    });
    _createPieChart();
    setState(() {
      loading = false;
    });
  }

  _createPieChart() {
    series = [
      new charts.Series(
        id: 'Sales',
        domainFn: (Categories cate, _) => cate.catId,
        measureFn: (Categories cate, _) => cate.totalAmt,
        data: catExpList,
        labelAccessorFn: (Categories cate, _) => cate.totalAmt == 0.0
            ? null
            : "\$ " + cate.totalAmt.toString().replaceAllMapped(reg, mathFunc),
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
                            _monthFormat.format(DateTime.now()).toUpperCase(),
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
                        ? charts.PieChart(
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
                        : Center(
                            child: CircularProgressIndicator(),
                          )),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 150.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {},
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      color: Color(0xFFFE5F55),
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
                            width: 150.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {},
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      color: Color(0xFF52D1DC),
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
                            width: 150.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {},
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      color: Color(0xFF8661C1),
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
                            width: 150.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {},
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      color: Color(0xFF7097A8),
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
                            width: 150.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  _generateReport('Medical/Healthcare');
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      color: Color(0xFF1EA896),
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
                            width: 150.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {},
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      color: Color(0xFFF5853F),
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
                            width: 150.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {},
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      color: Color(0xFFFFE787),
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
                            width: 150.0,
                            height: 15.0,
                            margin: EdgeInsets.all(4.0),
                            child: Container(
                              child: FlatButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {},
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      width: 10.0,
                                      height: 10.0,
                                      color: Color(0xFF19647E),
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
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
