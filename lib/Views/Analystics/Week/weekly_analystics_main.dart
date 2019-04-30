import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Models/Expense/expense.dart';
import '../../../Views/Analystics/Week/weekly_category.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import '../../../Database/expense_db.dart';

class WeekAnalystics extends StatefulWidget {
  @override
  _WeekAnalysticsState createState() => _WeekAnalysticsState();
}

class _WeekAnalysticsState extends State<WeekAnalystics> {
  DBProvider _dbProvider = DBProvider();
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  DateFormat _dateFormat = DateFormat("dd MMM yyyy");
  DateFormat _queryDF = DateFormat("yyyy-MM-dd");
  DateTime currentDate = DateTime.now();
  String startDate;
  String endDate;
  String getStartDate;
  String getEndDate;
  List<Expense> clothingList = [];
  List<Expense> entertainmentList = [];
  List<Expense> foodList = [];
  List<Expense> donateList = [];
  List<Expense> healthcareList = [];
  List<Expense> personalList = [];
  List<Expense> transportationList = [];
  List<Expense> utilitiesList = [];
  List<List<Expense>> categoryList = [];
  bool loading = true;
  List<double> totalAmtList = [];
  double allCateAmt = 0.0;

  var series;
  @override
  void initState() {
    super.initState();
    setDate();
  }

  setDate() async {
    if (currentDate.weekday == 7) {
      getStartDate = _queryDF.format(currentDate);
      getEndDate = _queryDF.format(currentDate.add(Duration(days: 6)));
      startDate = _dateFormat.format(currentDate);
      endDate = _dateFormat.format(currentDate.add(Duration(days: 6)));
    } else if (currentDate.weekday == 1) {
      getStartDate = _queryDF.format(currentDate.subtract(Duration(days: 1)));
      getEndDate = _queryDF.format(currentDate.add(Duration(days: 5)));
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 1)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 5)));
    } else if (currentDate.weekday == 2) {
      getStartDate = _queryDF.format(currentDate.subtract(Duration(days: 2)));
      getEndDate = _queryDF.format(currentDate.add(Duration(days: 4)));
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 2)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 4)));
    } else if (currentDate.weekday == 3) {
      getStartDate = _queryDF.format(currentDate.subtract(Duration(days: 3)));
      getEndDate = _queryDF.format(currentDate.add(Duration(days: 3)));
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 3)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 3)));
    } else if (currentDate.weekday == 4) {
      getStartDate = _queryDF.format(currentDate.subtract(Duration(days: 4)));
      getEndDate = _queryDF.format(currentDate.add(Duration(days: 2)));
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 4)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 2)));
    } else if (currentDate.weekday == 5) {
      getStartDate = _queryDF.format(currentDate.subtract(Duration(days: 5)));
      getEndDate = _queryDF.format(currentDate.add(Duration(days: 1)));
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 5)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 1)));
    } else {
      getStartDate = _queryDF.format(currentDate.subtract(Duration(days: 6)));
      getEndDate = _queryDF.format(currentDate.add(Duration(days: 0)));
      startDate = _dateFormat.format(currentDate.subtract(Duration(days: 6)));
      endDate = _dateFormat.format(currentDate.add(Duration(days: 0)));
    }
    await generateWeekCateExp(getStartDate, getEndDate);
  }

  generateWeekCateExp(String startDate, String endDate) async {
    await _dbProvider
        .specificDateRangeExpense(startDate, endDate)
        .then((value) {
      categoryList.clear();
      clothingList.clear();
      entertainmentList.clear();
      foodList.clear();
      donateList.clear();
      healthcareList.clear();
      personalList.clear();
      transportationList.clear();
      utilitiesList.clear();
      for (var item in value) {
        if (item.category == "Clothing") {
          clothingList.add(item);
        } else if (item.category == "Entertainment") {
          entertainmentList.add(item);
        } else if (item.category == "Food") {
          foodList.add(item);
        } else if (item.category == "Gifts/Donations") {
          donateList.add(item);
        } else if (item.category == "Medical/Healthcare") {
          healthcareList.add(item);
        } else if (item.category == "Personal") {
          personalList.add(item);
        } else if (item.category == "Transportation") {
          transportationList.add(item);
        } else {
          utilitiesList.add(item);
        }
      }
      categoryList.add(clothingList);
      categoryList.add(entertainmentList);
      categoryList.add(foodList);
      categoryList.add(donateList);
      categoryList.add(healthcareList);
      categoryList.add(personalList);
      categoryList.add(transportationList);
      categoryList.add(utilitiesList);
      _calculateTotalAmt(categoryList);
    });
    setState(() {
      loading = false;
    });
  }

  _calculateTotalAmt(List<List<Expense>> catList) {
    totalAmtList.clear();
    allCateAmt = 0.0;
    for (var amt in catList) {
      var totalAmt = 0.0;
      for (var item in amt) {
        totalAmt += item.amount;
        allCateAmt += item.amount;
      }
      totalAmtList.add(totalAmt);
    }
  }

  _showDatePicker() async {
    final List<DateTime> picked = await DateRangePicker.showDatePicker(
      context: context,
      initialFirstDate: _dateFormat.parse(startDate),
      initialLastDate: _dateFormat.parse(endDate),
      firstDate: DateTime(1990),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked.length == 2) {
      setState(() {
        startDate = _dateFormat.format(picked[0]);
        endDate = _dateFormat.format(picked[1]);
        getStartDate = _queryDF.format(picked[0]);
        getEndDate = _queryDF.format(picked[1]);
      });
    }
    await generateWeekCateExp(getStartDate, getEndDate);
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
            body: loading == false
                ? SingleChildScrollView(
                    child: Container(
                      height: device.longestSide - kToolbarHeight - 24.0 - 50.0,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Date Range".toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF), fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                FlatButton(
                                  highlightColor: Colors.transparent,
                                  color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  onPressed: () {
                                    _showDatePicker();
                                  },
                                  child: Text(
                                    "$startDate - $endDate".toUpperCase(),
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 14.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          WeeklyCategory(
                            startDate: getStartDate,
                            endDate: getEndDate,
                            amtList: totalAmtList,
                            allCatList: categoryList,
                          ),
                          Container(
                            color: Color(0xFFFFFFFF),
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    "Total Expense".toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 18.0),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    "\$ " +
                                        allCateAmt
                                            .toString()
                                            .replaceAllMapped(reg, mathFunc),
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 18.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                    ),
                  ));
      },
    );
  }
}
