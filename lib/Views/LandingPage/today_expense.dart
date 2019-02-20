import 'package:flutter/material.dart';
import '../../Views/LandingPage/add_expense.dart';
import '../../Models/Expense/expense.dart';
import '../../Database/expense_db.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodayExpense extends StatefulWidget {
  final orientation;
  final actualHeight;
  TodayExpense({this.orientation, this.actualHeight});
  @override
  _TodayExpenseState createState() =>
      _TodayExpenseState(orientation: orientation, actualHeight: actualHeight);
}

class _TodayExpenseState extends State<TodayExpense> {
  final orientation;
  final actualHeight;
  _TodayExpenseState({this.orientation, this.actualHeight});

  final SlidableController slidableController = new SlidableController();
  var price = 'No expense';
  var item = 'No item';
  double finalAmt = 0.0;
  var loading = true;
  DateFormat _dateFormat = DateFormat('d MMM yyyy');

  Future<List<Expense>> getExpense() async {
    var db = DBProvider();
    Future<List<Expense>> expense = db.getLastExpense();
    return expense;
  }

  @override
  void initState() {
    super.initState();
    getExpense().then((data) {
      setState(() {
        loading = false;
      });
    });
  }

  _getTotal(List<Expense> expList) {
    finalAmt = 0.0;
    for (var expAmt in expList) {
      finalAmt += expAmt.amount;
    }
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: Colors.white,
            ),
            child: FutureBuilder<List<Expense>>(
              future: getExpense(),
              builder: (context, snap) {
                if (snap.hasData && snap.data.length != 0) {
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 24.0),
                        alignment: AlignmentDirectional.centerStart,
                        height: 50.0,
                        child: Text(
                          _dateFormat.format(DateTime.now()),
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.grey[900]),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(
                            height: 1.5,
                            color: Colors.black87,
                          )),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snap.data.length,
                          itemBuilder: (context, i) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: ListTile(
                                title: Text(snap.data[i].item),
                                subtitle: Text(snap.data[i].category),
                                trailing: Text(snap.data[i].amount.toString()),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListTile(
                          title: Text("Total"),
                          trailing: Text(finalAmt.toString()),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                      child: new Text(
                    "No Expense List",
                    style: TextStyle(fontSize: 18.0),
                  ));
                }
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      height: device.height <= 600 && orientation == Orientation.portrait
          ? actualHeight / 2
          : orientation == Orientation.landscape
              ? actualHeight / 1.2
              : actualHeight / 2.5,
      width: device.width,
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        elevation: 7.2,
        color: Color(0xFFF2F6F7),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
                    child: Text(
                      "Today Expense",
                      style: TextStyle(
                          fontSize: device.height <= 600 &&
                                  orientation == Orientation.portrait
                              ? 14.0
                              : 18.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF31373F)),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(
                      left: 16.0,
                    ),
                    width: device.width / 3 - 32.0,
                    height: 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.redAccent,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: device.width / 3 - 16.0,
                        height: device.height <= 600 &&
                                orientation == Orientation.portrait
                            ? actualHeight / 2.5 - 70
                            : orientation == Orientation.landscape
                                ? actualHeight / 1.2 - 120
                                : actualHeight / 3 - 70,
                        child: Icon(
                          Icons.monetization_on,
                          size: 126.0,
                          color: Colors.black45,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 16.0,
                            top: orientation == Orientation.landscape
                                ? 16.0
                                : 8.0),
                        width: device.width / 1.5 - 16.0,
                        height: device.height <= 600 &&
                                orientation == Orientation.portrait
                            ? actualHeight / 2.5 - 70
                            : orientation == Orientation.landscape
                                ? actualHeight / 1.2 - 120
                                : actualHeight / 3 - 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Last Expense'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: device.height <= 600 &&
                                          orientation == Orientation.portrait
                                      ? 12.0
                                      : 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: FutureBuilder(
                                future: getExpense(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data.length != 0) {
                                    price = snapshot.data[0].amount.toString();
                                    return Text(
                                      price,
                                      style: TextStyle(
                                        color: Color(0xFF31373F),
                                        fontSize: device.height <= 600 &&
                                                orientation ==
                                                    Orientation.portrait
                                            ? 12.0
                                            : 16.0,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      price,
                                      style: TextStyle(
                                        color: Color(0xFF31373F),
                                        fontSize: device.height <= 600 &&
                                                orientation ==
                                                    Orientation.portrait
                                            ? 12.0
                                            : 16.0,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: FutureBuilder(
                                future: getExpense(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data.length != 0) {
                                    item = snapshot.data[0].item;
                                    return Text(
                                      item,
                                      style: TextStyle(
                                        color: Color(0xFF31373F),
                                        fontSize: device.height <= 600 &&
                                                orientation ==
                                                    Orientation.portrait
                                            ? 14.0
                                            : 16.0,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      item,
                                      style: TextStyle(
                                        color: Color(0xFF31373F),
                                        fontSize: device.height <= 600 &&
                                                orientation ==
                                                    Orientation.portrait
                                            ? 14.0
                                            : 16.0,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Divider(
                              color: Colors.black87,
                              height: 25.0,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 8.0, right: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Total Expense".toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: device.height <= 600 &&
                                                orientation ==
                                                    Orientation.portrait
                                            ? 16.0
                                            : 16.0),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
                                    margin: EdgeInsets.only(left: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.black45,
                                    ),
                                    child: FutureBuilder(
                                      future: getExpense(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data.length != 0) {
                                          var data = snapshot.data;
                                          _getTotal(data);
                                          return Text(
                                            finalAmt.toString(),
                                            style: TextStyle(
                                                fontSize: device.height <=
                                                            600 &&
                                                        orientation ==
                                                            Orientation.portrait
                                                    ? 12.0
                                                    : 14.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white70),
                                          );
                                        } else {
                                          return Text(
                                            finalAmt.toString(),
                                            style: TextStyle(
                                                fontSize: device.height <=
                                                            600 &&
                                                        orientation ==
                                                            Orientation.portrait
                                                    ? 12.0
                                                    : 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white70),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 16.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          color: Colors.redAccent,
                          child: Text("Add Expense",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddExpense()));
                          }, //_addRecord,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          color: Colors.redAccent,
                          child: Text("Expense List",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          onPressed: _showModalSheet,
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
