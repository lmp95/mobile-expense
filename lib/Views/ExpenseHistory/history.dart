import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:intl/intl.dart';
import '../../Database/expense_db.dart';
import '../../Models/Expense/expense.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  var series;

  @override
  void initState() {
    super.initState();
    _charts();
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

  _deleteDialog() {
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
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    "No".toUpperCase(),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  _charts() {
    var data = [
      new Expense(category: 'Clothing', amount: 2350.0),
      new Expense(category: 'Entertainment', amount: 3200.0),
      new Expense(category: 'Food', amount: 1200.0),
      new Expense(category: 'Gifts/Donations', amount: 3000.0),
      new Expense(category: 'Medical/Healthcare', amount: 1000.0),
      new Expense(category: 'Personal', amount: 2100.0),
      new Expense(category: 'Transportation', amount: 500.0),
      new Expense(category: 'Utilities', amount: 3400.0),
    ];
    series = [
      new charts.Series<Expense, String>(
          id: 'Sales',
          domainFn: (Expense sales, _) => sales.category,
          measureFn: (Expense sales, _) => sales.amount,
          data: data,
          labelAccessorFn: (Expense sales, _) =>
              '${sales.category}: \$${sales.amount.toString()}')
    ];
  }

  _showChart(String selectedDate) {
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
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              padding: EdgeInsets.all(16.0),
              child: Text(
                selectedDate,
                style: TextStyle(color: Colors.white),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: charts.BarChart(
                      series,
                      vertical: false,
                      barRendererDecorator:
                          new charts.BarLabelDecorator<String>(),
                      domainAxis: new charts.OrdinalAxisSpec(
                          renderSpec: new charts.NoneRenderSpec()),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0))),
                  width: 1000.0,
                  child: FlatButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            contentPadding: EdgeInsets.all(0.0),
          );
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
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            iconSize: 28.0,
                            onPressed: () {
                              _showChart(selectedDate);
                            },
                            icon: Icon(Icons.show_chart),
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
                                          onTap: _deleteDialog,
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
