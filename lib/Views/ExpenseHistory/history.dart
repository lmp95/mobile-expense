import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:intl/intl.dart';
import '../../Database/expense_db.dart';
import '../../Models/Expense/expense.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final SlidableController slidableController = SlidableController();
  var selectedDate;
  var queryDate;
  var random;
  DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  DateFormat _queryDateFormat = DateFormat('yyyy-MM-dd');
  var db = DBProvider();
  Expense _expense;
  List<Expense> _listExp = [];
  var _loading = true;
  var priceTotal = 0.0;

  @override
  void initState() {
    super.initState();
    random = 0;
    selectedDate = _dateFormat.format(DateTime.now()).toString();
    queryDate = _queryDateFormat.format(DateTime.now());
    var data = db.historyExpense(queryDate);
    data.then((value) {
      if (value.length != null) {
        for (var item in value) {
          priceTotal += item.amount;
          _expense = Expense(
            id: item.id,
            item: item.item,
            category: item.category,
            amount: item.amount,
            date: item.date,
            year: item.year,
          );
          _listExp.add(_expense);
        }
        setState(() {
          _loading = false;
        });
      }
    });
  }

  _getHistory(String date) {
    _listExp.clear();
    priceTotal = 0.0;
    var getData = db.historyExpense(date);
    getData.then((value) {
      if (value.length != 0) {
        for (var item in value) {
          priceTotal += item.amount;
          _expense = Expense(
            id: item.id,
            item: item.item,
            category: item.category,
            amount: item.amount,
            date: item.date,
            year: item.year,
          );
          _listExp.add(_expense);
        }
        setState(() {
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          print("No History");
        });
      }
    });
  }

  changedDate(DateTime date) {
    setState(() {
      _loading = true;
      selectedDate = _dateFormat.format(date);
      queryDate = _queryDateFormat.format(date);
      var data = db.historyExpense(queryDate);
      data.then((value) {
        setState(() {
          _getHistory(_queryDateFormat.format(date));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('History'),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: orientation == Orientation.portrait
                  ? devHeight
                  : MediaQuery.of(context).size.longestSide / 1.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Theme(
                    data: ThemeData(
                      primarySwatch: Colors.red,
                    ),
                    child: Calendar(
                      onDateSelected: (value) {
                        changedDate(value);
                      },
                    ),
                  ),
                  Container(
                    color: Colors.black54,
                    padding: EdgeInsets.all(16.0),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      selectedDate.toUpperCase(),
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: _loading == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _listExp.length != 0
                              ? ListView.builder(
                                  itemCount: _listExp.length,
                                  itemBuilder: (context, i) {
                                    return Slidable(
                                      controller: slidableController,
                                      closeOnScroll: false,
                                      actionExtentRatio: 0.125,
                                      delegate: SlidableDrawerDelegate(),
                                      child: Container(
                                        child: ListTile(
                                          title: Text(
                                            _listExp[i].item,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18.0),
                                          ),
                                          subtitle: Text(
                                            _listExp[i].category,
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          trailing: Text(
                                            _listExp[i].amount.toString(),
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 17.0),
                                          ),
                                        ),
                                      ),
                                      secondaryActions: <Widget>[
                                        SlideAction(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                color: Colors.grey[350]),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                        SlideAction(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
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
                                )
                              : Center(
                                  child: Text(
                                    "No History",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                  Container(
                      color: Colors.redAccent,
                      child: ListTile(
                        title: Text(
                          "Total",
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                        trailing: Text(
                          priceTotal.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
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
