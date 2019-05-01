import 'package:flutter/material.dart';
import '../../Views/ExpenseHistory/history.dart';
import '../../Views/Income/income.dart';
import '../../Views/Analystics/Month/analystics_main.dart';
import '../../Views/Analystics/Year/analystics_main_year.dart';
import '../../Views/Analystics/Week/weekly_analystics_main.dart';

class NavigateBtn extends StatefulWidget {
  @override
  _NavigateBtnState createState() => _NavigateBtnState();
}

class _NavigateBtnState extends State<NavigateBtn> {
  @override
  void initState() {
    super.initState();
  }

  void _showBtns() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 66.0),
                color: Color(0xFF31373F),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WeekAnalystics()));
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "Icons/xxxhdpi/weekly.png",
                              height: 36,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Week".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AnalysticsMain(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "Icons/xxxhdpi/monthly.png",
                              height: 36,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Month".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  YearlyAnalysticsMain(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "Icons/xxxhdpi/yearly.png",
                              height: 36,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Year".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: (device.width / 2) - 16.0,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.redAccent),
            child: FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                _showBtns();
              },
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0),
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      maxRadius: 36.0,
                      child: Icon(
                        Icons.show_chart,
                        size: 56.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 8.0, right: 16.0, bottom: 12.0),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Analytics",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: device.longestSide > 700 ? 18.0 : 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  width: (device.width / 2) - 16.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF38C8DD),
                  ),
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => History(
                                initialDate: DateTime.now(),
                              ),
                        ),
                      );
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 12.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black12,
                            child: Icon(
                              Icons.money_off,
                              size: 32.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            "Daily Expense",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    device.longestSide > 700 ? 16.0 : 13.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4.0),
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  width: (device.width / 2) - 16.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF7D60BE)),
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Income()));
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 12.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black12,
                            child: Icon(
                              Icons.attach_money,
                              size: 32.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            "Monthly Income",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    device.longestSide > 700 ? 16.0 : 13.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
