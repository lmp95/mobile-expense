import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/Expense/expense.dart';
import '../../Views/LandingPage/today_expense.dart';
import '../../Database/expense_db.dart';
import '../../Views/LandingPage/navigate_btns.dart';
import '../LandingPage/this_month_expense.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '';

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
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbProvider.initDb();
  }

  BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3019709491358398/9141763478',
    size: AdSize.smartBanner,
    targetingInfo: targetInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-3019709491358398~8563588097')
        .then((result) {
      myBanner
        ..load()
        ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
    });
    var dev = MediaQuery.of(context).size;
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
              height: dev.longestSide - 30.0,
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

MobileAdTargetingInfo targetInfo = MobileAdTargetingInfo(
  keywords: <String>['expense', 'finance'],
  contentUrl: '',
  birthday: DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender: MobileAdGender.unknown,
  testDevices: <String>[],
);
