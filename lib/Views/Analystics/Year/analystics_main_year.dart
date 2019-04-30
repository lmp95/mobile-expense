import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../Analystics/Year/category_list.dart';
import 'package:flutter_picker/flutter_picker.dart';
import '../../Analystics/Year/year_list.dart';
import '../../../Database/expense_db.dart';
import '../../../Models/Analystic/annual_expense.dart';
import '../../../Views/Analystics/Year/annual_report.dart';
import '../../../Models/Analystic/annual_category.dart';
import '../../Analystics/Year/dummy_chart_data.dart';

class YearlyAnalysticsMain extends StatefulWidget {
  @override
  _YearlyAnalysticsMainState createState() => _YearlyAnalysticsMainState();
}

class _YearlyAnalysticsMainState extends State<YearlyAnalysticsMain> {
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  var dataList;
  String _currentYear = DateTime.now().year.toString();
  DBProvider _dbProvider = DBProvider();
  double annualTotal = 0.0;
  List<Annual> clothingList = [];
  List<Annual> entertainList = [];
  List<Annual> foodList = [];
  List<Annual> giftsList = [];
  List<Annual> healthList = [];
  List<Annual> personalList = [];
  List<Annual> transportList = [];
  List<Annual> utilitiesList = [];
  bool loading = true;
  var data;
  var chart;
  var pieChart = true;

  @override
  void initState() {
    super.initState();
    _generateList();
  }

  _generateChart() {
    chart = [
      charts.Series<AnnualCategory, int>(
        id: 'Sales',
        domainFn: (AnnualCategory cate, _) => cate.category,
        measureFn: (AnnualCategory cate, _) => cate.totalAmt,
        data: pieChart == false ? dummyList : data,
        labelAccessorFn: (AnnualCategory cate, _) => pieChart == false
            ? null
            : cate.totalAmt == 0.0
                ? null
                : "\$ " +
                    cate.totalAmt.toString().replaceAllMapped(reg, mathFunc),
        colorFn: (AnnualCategory cate, _) => cate.color,
      )
    ];
  }

  _generateList() async {
    clothingList.clear();
    entertainList.clear();
    foodList.clear();
    giftsList.clear();
    healthList.clear();
    personalList.clear();
    transportList.clear();
    utilitiesList.clear();
    await _dbProvider.getAnnualCatExp(_currentYear).then((results) {
      annualTotal = 0.0;
      for (var result in results) {
        annualTotal += result.totalAmt;
        if (result.category == "Clothing") {
          clothingList.add(result);
        } else if (result.category == "Entertainment") {
          entertainList.add(result);
        } else if (result.category == "Food") {
          foodList.add(result);
        } else if (result.category == "Gifts/Donations") {
          giftsList.add(result);
        } else if (result.category == "Medical/Healthcare") {
          healthList.add(result);
        } else if (result.category == "Personal") {
          personalList.add(result);
        } else if (result.category == "Transportation") {
          transportList.add(result);
        } else {
          utilitiesList.add(result);
        }
        if (annualTotal == 0.0) {
          setState(() {
            pieChart = false;
          });
        } else {
          setState(() {
            pieChart = true;
          });
        }
      }
    });
    await _dbProvider.annualCatExp(_currentYear).then((results) {
      data = results;
    });
    _createLineChart();
    _generateChart();
    setState(() {
      loading = false;
    });
  }

  _createLineChart() {
    dataList = [
      new charts.Series(
        id: 'Clothing',
        domainFn: (Annual anul, _) => anul.month,
        measureFn: (Annual anul, _) => anul.totalAmt,
        data: clothingList,
        colorFn: (Annual anul, _) => anul.color,
      ),
      new charts.Series(
        id: 'Entertainment',
        domainFn: (Annual anul, _) => anul.month,
        measureFn: (Annual anul, _) => anul.totalAmt,
        data: entertainList,
        colorFn: (Annual anul, _) => anul.color,
      ),
      new charts.Series(
        id: 'Food',
        domainFn: (Annual anul, _) => anul.month,
        measureFn: (Annual anul, _) => anul.totalAmt,
        data: foodList,
        colorFn: (Annual anul, _) => anul.color,
      ),
      new charts.Series(
        id: 'Gifts',
        domainFn: (Annual anul, _) => anul.month,
        measureFn: (Annual anul, _) => anul.totalAmt,
        data: giftsList,
        colorFn: (Annual anul, _) => anul.color,
      ),
      new charts.Series(
        id: 'Medical',
        domainFn: (Annual anul, _) => anul.month,
        measureFn: (Annual anul, _) => anul.totalAmt,
        data: healthList,
        colorFn: (Annual anul, _) => anul.color,
      ),
      charts.Series(
        id: 'Personal',
        domainFn: (Annual anul, _) => anul.month,
        measureFn: (Annual anul, _) => anul.totalAmt,
        data: personalList,
        colorFn: (Annual anul, _) => anul.color,
      ),
      charts.Series(
        id: 'Transportation',
        domainFn: (Annual anul, _) => anul.month,
        measureFn: (Annual anul, _) => anul.totalAmt,
        data: transportList,
        colorFn: (Annual anul, _) => anul.color,
      ),
      charts.Series(
        id: 'Utilities',
        domainFn: (Annual anul, _) => anul.month,
        measureFn: (Annual anul, _) => anul.totalAmt,
        data: utilitiesList,
        colorFn: (Annual anul, _) => anul.color,
      ),
    ];
  }

  _showYearDialog() {
    var currentIndex = _currentYear.toString().substring(2);
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(YearList), isArray: true),
        hideHeader: true,
        selecteds: [
          int.parse(currentIndex),
        ],
        textStyle: TextStyle(fontSize: 16.0, color: Colors.black87),
        title: new Text("Choose Year"),
        onConfirm: (Picker picker, List value) {
          setState(() {
            _currentYear = picker
                .getSelectedValues()
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '');
            loading = true;
          });
          _generateList();
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (buidcontext, orientation) {
        return Scaffold(
          backgroundColor: Color(0xFF31373F),
          appBar: AppBar(
            title: Text("Analystics"),
            elevation: 0.0,
          ),
          body: loading == false
              ? SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    height: device.longestSide,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 16.0, left: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Annual Expense",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(0.0),
                                color: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                onPressed: () {
                                  _showYearDialog();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _currentYear,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          height: device.longestSide / 3,
                          child: Stack(
                            children: [
                              annualTotal == 0.0
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "No Data Available",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              charts.BarChart(
                                dataList,
                                domainAxis: charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                    labelStyle: new charts.TextStyleSpec(
                                        fontSize: 10,
                                        color: charts.MaterialPalette.white),
                                    lineStyle: new charts.LineStyleSpec(
                                        color: charts.MaterialPalette.white),
                                  ),
                                ),
                                primaryMeasureAxis: charts.NumericAxisSpec(
                                  renderSpec: charts.GridlineRendererSpec(
                                    labelStyle: new charts.TextStyleSpec(
                                      fontSize: 10,
                                      color: charts.MaterialPalette.white,
                                    ),
                                    lineStyle: new charts.LineStyleSpec(
                                      thickness: 0,
                                      color: charts.MaterialPalette.white,
                                    ),
                                  ),
                                ),
                                barGroupingType: charts.BarGroupingType.stacked,
                              ),
                            ],
                          ),
                        ),
                        YearlyCategoryList(
                          selectedYear: _currentYear,
                        ),
                        AnnualChart(
                          chart: chart,
                          pieChart: pieChart,
                          annualTotal: annualTotal,
                        )
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    width: device.width / 1.5,
                    height: 1.5,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
