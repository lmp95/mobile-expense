import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Views/Income/income_form.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../Database/expense_db.dart';
import '../../Models/Income/income.dart' as IncomeModel;
import 'package:flutter_slidable/flutter_slidable.dart';

class Income extends StatefulWidget {
  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  DateFormat _dtFormat = DateFormat("MMMM");
  DateFormat _queryDt = DateFormat("M");
  DateFormat _displaydt = DateFormat("dd-MMM-yyyy");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SlidableController slidableController = SlidableController();
  var _currentDate = DateTime.now();
  DBProvider db = DBProvider();
  var totalIncomeAmt = 0.0;
  var getMonth = DateTime.now().month.toString();
  var incomeList = [];
  var _loading = true;
  Future<List<IncomeModel.Income>> fetchIncome(String mnth) async {
    var historyIncome = await db.getMonthlyIncome(mnth);
    setState(() {
      _loading = false;
    });
    return historyIncome;
  }

  @override
  void initState() {
    super.initState();
    fetchIncome(getMonth);
  }

  _totalIncome(List<IncomeModel.Income> incomeList) {
    totalIncomeAmt = 0.0;
    for (var income in incomeList) {
      totalIncomeAmt += income.amount;
    }
  }

  _setDate(DateTime date) async {
    setState(() {
      _loading = true;
      _currentDate = date;
      getMonth = _queryDt.format(date);
      fetchIncome(getMonth);
    });
  }

  _showModalSheet() {
    showMonthPicker(context: context, initialDate: _currentDate).then((date) {
      if (date == null) {
        setState(() {
          _currentDate = _currentDate;
          _setDate(_currentDate);
        });
      } else {
        setState(() {
          _currentDate = date;
          _setDate(_currentDate);
        });
      }
    });
  }

  _deleteIncome(int deleteID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Delete Income"),
            content: Text("Are you sure to delete?"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  "Yes".toUpperCase(),
                ),
                onPressed: () {
                  db.deleteIncome(deleteID);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  "No".toUpperCase(),
                  style: TextStyle(color: Colors.grey[800]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dev = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            title: Text("Income"),
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.all(0.0),
                color: Color.fromRGBO(0, 0, 0, 0.05),
                width: dev.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 75.0,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              _dtFormat.format(_currentDate).toUpperCase(),
                              style: TextStyle(
                                  color: Color(0xFF31373F),
                                  fontSize: dev.longestSide > 600 ? 24.0 : 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 75.0,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              "Total Income".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: dev.longestSide > 600 ? 12.0 : 10.0,
                                  letterSpacing: 1.25,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.attach_money,
                                  color: Colors.red,
                                  size: 28.0,
                                ),
                              ),
                              Container(
                                child: FutureBuilder(
                                  future: db.getMonthlyIncome(getMonth),
                                  builder: (buildcontext, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data.length != 0) {
                                      _totalIncome(snapshot.data);
                                      return Text(
                                        totalIncomeAmt
                                            .toString()
                                            .replaceAllMapped(reg, mathFunc),
                                        style: TextStyle(
                                            color: Color(0xFF31373F),
                                            fontSize: dev.longestSide > 600
                                                ? 20.0
                                                : 18.0,
                                            fontWeight: FontWeight.w100),
                                      );
                                    } else {
                                      return Text(
                                        "0.0",
                                        style: TextStyle(
                                            color: Color(0xFF31373F),
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w100),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Monthly Income List",
                        style: TextStyle(fontSize: 20.0),
                      ),
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
                                  dt: _currentDate,
                                ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            (Icons.add),
                          ),
                          Text(
                            "Add Income",
                            style: TextStyle(fontSize: 16.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : FutureBuilder(
                        future: fetchIncome(getMonth),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data.length != 0) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (buildcontext, i) {
                                return Slidable(
                                  controller: slidableController,
                                  closeOnScroll: false,
                                  actionExtentRatio: 0.125,
                                  delegate: SlidableScrollDelegate(),
                                  child: Container(
                                    color: Color(0xB331373F),
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data[i].description,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        _displaydt.format(DateTime.parse(
                                            snapshot.data[i].date)),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: Text(
                                        "\$ " +
                                            snapshot.data[i].amount
                                                .toString()
                                                .replaceAllMapped(
                                                    reg, mathFunc),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                  secondaryActions: <Widget>[
                                    Container(
                                      color: Color(0xB331373F),
                                      child: SlideAction(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          IncomeForm(
                                                            dt: DateTime.parse(
                                                                snapshot.data[i]
                                                                    .date),
                                                            editIncome: snapshot
                                                                .data[i],
                                                          )));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              color: Colors.grey[350]),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black54,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xB331373F),
                                      child: SlideAction(
                                        onTap: () {
                                          _deleteIncome(snapshot.data[i].id);
                                        },
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
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Container(
                              child: Center(
                                child: Text(
                                  "No Income List",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            );
                          }
                        },
                      ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            tooltip: "Choose Date",
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            onPressed: () {
              _showModalSheet();
            },
            label: Text(
              "Month",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        );
      },
    );
  }
}
