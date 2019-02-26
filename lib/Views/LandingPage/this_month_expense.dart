import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../Views/Income/income_form.dart';
import '../../Database/expense_db.dart';
import '../../Models/Expense/expense.dart';
import '../../Models/Income/income.dart';

class ThisMonthExpense extends StatefulWidget {
  @override
  _ThisMonthExpenseState createState() => _ThisMonthExpenseState();
}

class _ThisMonthExpenseState extends State<ThisMonthExpense> {
  var _incomeTotal = 0.0;
  DBProvider db = DBProvider();
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  var finalAmt;
  var totalIncome;
  var totalExp;

  @override
  void initState() {
    super.initState();
    _getPercentage();
  }

  Future<String> _getPercentage() async {
    var thisMonth = DateTime.now().month.toString();
    totalIncome = 0.0;
    totalExp = 0.0;
    List<Expense> expList = [];
    List<Income> incomeList = [];
    await db.getMonthlyExpense(thisMonth).then((data) => expList = data);
    await db.getMonthlyIncome(thisMonth).then((data) => incomeList = data);
    for (var exp in expList) {
      totalExp += exp.amount;
    }
    for (var income in incomeList) {
      totalIncome += income.amount;
    }
    return (totalExp / totalIncome).toString();
  }

  _getTotal(List<Expense> expList) {
    finalAmt = 0.0;
    for (var expAmt in expList) {
      finalAmt += expAmt.amount;
    }
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "This Month",
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => IncomeForm(
                              dt: DateTime.now(),
                            ),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 20.0,
                        color: Colors.redAccent,
                      ),
                      Text(
                        "Add Income",
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      ),
                    ],
                  ),
                )
              ],
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
                  child: FutureBuilder(
                    future: _getPercentage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != "NaN" &&
                            snapshot.data != "Infinity" &&
                            double.parse(snapshot.data) <= 1.0) {
                          return LinearPercentIndicator(
                            trailing: Text(
                              (double.parse(snapshot.data) * 100)
                                      .toStringAsFixed(2) +
                                  " %",
                              style: TextStyle(color: Colors.white54),
                            ),
                            alignment: MainAxisAlignment.center,
                            width: device.width - 124.0,
                            lineHeight: 2.5,
                            percent: double.parse(snapshot.data),
                            backgroundColor: Colors.white70,
                            progressColor: Colors.redAccent,
                          );
                        } else if (snapshot.data != "NaN" &&
                            snapshot.data == "Infinity") {
                          return Text(
                            "Please add income to display percentage",
                            style: TextStyle(color: Colors.white54),
                          );
                        } else if (double.parse(snapshot.data) > 1.0) {
                          var overExp = _incomeTotal - finalAmt;
                          return Text(
                            "over-expenditurel     ".toUpperCase() +
                                "\$" +
                                overExp
                                    .toString()
                                    .replaceAllMapped(reg, mathFunc),
                            style: TextStyle(color: Colors.white54),
                          );
                        } else {
                          return LinearPercentIndicator(
                            trailing: Text(
                              "0.0 %",
                              style: TextStyle(color: Colors.white54),
                            ),
                            alignment: MainAxisAlignment.center,
                            width: device.width - 112.0,
                            lineHeight: 2.5,
                            percent: 0.0,
                            backgroundColor: Colors.white70,
                            progressColor: Colors.redAccent,
                          );
                        }
                      } else {
                        return Container(
                          width: device.width - 112.0,
                          height: 1.5,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white70,
                          ),
                        );
                      }
                    },
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
                          FutureBuilder(
                            future: db.getMonthlyIncome(
                                DateTime.now().month.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data.length != 0) {
                                var results = snapshot.data;
                                _incomeTotal = 0.0;
                                for (var income in results) {
                                  _incomeTotal += income.amount;
                                }
                                return Container(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "\$" +
                                        _incomeTotal
                                            .toString()
                                            .replaceAllMapped(reg, mathFunc),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        letterSpacing: 1.5),
                                  ),
                                );
                              } else {
                                return Container(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "\$ 0.0",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        letterSpacing: 1.5),
                                  ),
                                );
                              }
                            },
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
                            child: FutureBuilder(
                              future: db.getMonthlyExpense(
                                  DateTime.now().month.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data.length != 0) {
                                  var data = snapshot.data;
                                  _getTotal(data);
                                  return Text(
                                    "\$" +
                                        finalAmt
                                            .toString()
                                            .replaceAllMapped(reg, mathFunc),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        letterSpacing: 1.5),
                                  );
                                } else {
                                  return Text(
                                    "\$0.0",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        letterSpacing: 1.5),
                                  );
                                }
                              },
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
