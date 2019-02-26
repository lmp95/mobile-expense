import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/Expense/expense.dart';
import '../../Views/LandingPage/today_expense.dart';
import '../../Database/expense_db.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
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
                  TodayExpense(),
                  NavigateBtn(),
                  ThisMonthExpense(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
