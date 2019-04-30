import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:intl/intl.dart';
import '../../Database/expense_db.dart';
import '../../Models/Expense/expense.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../Views/ExpenseHistory/expense_form.dart';
import '../../Views/ExpenseHistory/daily_chart.dart';
import 'dart:async';

class History extends StatefulWidget {
  final DateTime initialDate;
  History({this.initialDate});
  @override
  _HistoryState createState() => _HistoryState(initialDate: initialDate);
}

class _HistoryState extends State<History> {
  final DateTime initialDate;
  _HistoryState({this.initialDate});
  final SlidableController slidableController = SlidableController();
  var selectedDate;
  var queryDate;
  DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  DateFormat _queryDateFormat = DateFormat('yyyy-MM-dd');
  var db = DBProvider();
  var _loading = true;
  var priceTotal = 0.0;
  var series;
  List<Expense> dataList = [];
  Future<List<Expense>> fetchExpense(DateTime dt) async {
    var queryDt = _queryDateFormat.format(dt);
    var historyExpense = await db.historyExpense(queryDt);
    setState(() {
      _loading = false;
    });
    return historyExpense;
  }

  @override
  void initState() {
    super.initState();
    selectedDate = _dateFormat.format(initialDate).toString();
    queryDate = _queryDateFormat.format(initialDate);
    fetchExpense(initialDate);
  }

  changedDate(DateTime date) {
    setState(() {
      _loading = true;
      selectedDate = _dateFormat.format(date);
      queryDate = _queryDateFormat.format(date);
      fetchExpense(date);
    });
  }

  _charts() {
    series = [
      new charts.Series<Expense, String>(
          id: 'Sales',
          domainFn: (Expense exps, _) => exps.category,
          measureFn: (Expense exps, _) => exps.amount,
          data: dataList,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          labelAccessorFn: (Expense exps, _) =>
              '${exps.category} - \$${exps.amount.toString()}')
    ];
  }

  _showChart(String selectedDate, Orientation orient) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF31373F),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              padding: EdgeInsets.all(16.0),
              child: Text(
                selectedDate,
                style: TextStyle(color: Colors.white),
              ),
            ),
            content: FutureBuilder(
              future: fetchExpense(_dateFormat.parse(selectedDate)),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.length != 0) {
                  var results = snapshot.data;
                  dataList = dailyChartFunction(results);
                  _charts();
                  return SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: orient == Orientation.portrait
                                ? MediaQuery.of(context).size.height / 2
                                : MediaQuery.of(context).size.longestSide / 3,
                            child: Container(
                                padding: EdgeInsets.all(16.0),
                                child: charts.BarChart(
                                  series,
                                  vertical: false,
                                  barRendererDecorator:
                                      new charts.BarLabelDecorator<String>(),
                                  domainAxis: new charts.OrdinalAxisSpec(
                                      renderSpec: new charts.NoneRenderSpec()),
                                )),
                          ),
                          Divider(
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: orient == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 4
                            : MediaQuery.of(context).size.height / 2,
                        alignment: AlignmentDirectional.center,
                        padding: EdgeInsets.all(16.0),
                        child: Text("Not Available"),
                      ),
                      Divider(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ],
                  );
                }
              },
            ),
            actions: <Widget>[
              FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.redAccent, fontSize: 18.0),
                ),
              ),
            ],
            contentPadding: EdgeInsets.all(0.0),
          );
        });
  }

  _deleteDialog(int deleteID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Delete Expense"),
              content: Text("Are you sure to delete?"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Yes".toUpperCase(),
                  ),
                  onPressed: () {
                    db.deleteExpense(deleteID);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    "No".toUpperCase(),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Expense'),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: orientation == Orientation.portrait
                  ? devHeight.longestSide - kToolbarHeight - 24.0 - 50.0
                  : MediaQuery.of(context).size.longestSide / 1.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Calendar(
                    initialCalendarDateOverride: initialDate,
                    onDateSelected: (value) {
                      changedDate(value);
                    },
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate.toUpperCase(),
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black87),
                        ),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                tooltip: "Add Expense",
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                iconSize: 28.0,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ExpenseForm(
                                                selectedDate: selectedDate,
                                              )));
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black54,
                                ),
                              ),
                              IconButton(
                                tooltip: "View Chart",
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                iconSize: 28.0,
                                onPressed: () {
                                  _showChart(selectedDate, orientation);
                                },
                                icon: Icon(
                                  Icons.show_chart,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: _loading == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : FutureBuilder<List<Expense>>(
                              future:
                                  fetchExpense(_dateFormat.parse(selectedDate)),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data.length != 0) {
                                  var dataList = snapshot.data;
                                  return ListView.builder(
                                    itemCount: dataList.length,
                                    itemBuilder: (context, i) {
                                      return Slidable(
                                        controller: slidableController,
                                        closeOnScroll: false,
                                        actionExtentRatio: 0.125,
                                        delegate: SlidableDrawerDelegate(),
                                        child: Container(
                                          child: ListTile(
                                            title: Text(
                                              dataList[i].item,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18.0),
                                            ),
                                            subtitle: Text(
                                              dataList[i].category,
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              dataList[i].amount.toString(),
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        secondaryActions: <Widget>[
                                          SlideAction(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ExpenseForm(
                                                            selectedDate:
                                                                selectedDate,
                                                            expense:
                                                                dataList[i],
                                                          )));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  color: Colors.grey[350]),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                          SlideAction(
                                            onTap: () {
                                              _deleteDialog(dataList[i].id);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  color: Colors.redAccent),
                                              child: Icon(
                                                Icons.delete_outline,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      "No History",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                  ),
                  Container(
                      color: Color(0xFF31373F),
                      child: FutureBuilder(
                        future: fetchExpense(_dateFormat.parse(selectedDate)),
                        builder: (buildcontext, snapshot) {
                          if (snapshot.hasData && snapshot.data.length != 0) {
                            var totalPrice = 0.0;
                            for (var item in snapshot.data) {
                              totalPrice += item.amount;
                            }
                            return ListTile(
                              title: Text(
                                "Total",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                              trailing: Text(
                                totalPrice.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                            );
                          } else {
                            return ListTile(
                              title: Text(
                                "Total",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                              trailing: Text(
                                "0.0",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
