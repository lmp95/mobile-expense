import 'package:flutter/material.dart';
import '../../Views/LandingPage/get_monthly_income.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ThisMonthExpense extends StatefulWidget {
  @override
  _ThisMonthExpenseState createState() => _ThisMonthExpenseState();
}

class _ThisMonthExpenseState extends State<ThisMonthExpense> {
  @override
  void initState() {
    super.initState();
    var data = getMnthlyIncome();
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              "This Month",
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(35, 0, 0, 0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: LinearPercentIndicator(
                    trailing: Text(
                      ((72000.0 / 360000.0) * 100).toString() + " %",
                      style: TextStyle(color: Colors.white54),
                    ),
                    alignment: MainAxisAlignment.center,
                    width: device.width - 112.0,
                    lineHeight: 2.5,
                    percent: 72000.0 / 360000.0,
                    backgroundColor: Colors.white70,
                    progressColor: Colors.redAccent,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Total Income".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 12.0,
                                  letterSpacing: 2.0),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              "\$360,000.0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Total Expense".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12.0,
                                  letterSpacing: 2.0),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              "\$72,000.0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
