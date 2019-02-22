import 'package:flutter/material.dart';
import '../../Database/expense_db.dart';
import '../../Models/Income/income.dart';
import 'package:intl/intl.dart';

class AddIncome extends StatefulWidget {
  final DateTime dt;
  final Income editIncome;
  AddIncome({this.dt, this.editIncome});
  @override
  _AddIncomeState createState() =>
      _AddIncomeState(dt: dt, editIncome: editIncome);
}

class _AddIncomeState extends State<AddIncome> {
  final DateTime dt;
  final Income editIncome;
  _AddIncomeState({this.dt, this.editIncome});
  TextEditingController incomeAmt = TextEditingController();
  TextEditingController incomeDesc = TextEditingController();
  final _incomeFormKey = GlobalKey<FormState>();
  DBProvider db = DBProvider();
  Income income;
  DateFormat dtFormat = DateFormat("yyyy-MM-dd");
  DateFormat _dateFormat = DateFormat("dd MMM yyyy");

  initState() {
    super.initState();
    if (editIncome != null) {
      setState(() {
        incomeAmt.text = editIncome.amount.toString();
        incomeDesc.text = editIncome.description;
      });
    }
  }

  _saveIncome() {
    if (editIncome == null) {
      if (_incomeFormKey.currentState.validate() == true) {
        _incomeFormKey.currentState.save();
        income = Income(
          description: incomeDesc.text,
          amount: double.parse(incomeAmt.text),
          date: dtFormat.format(dt),
          month: dt.month.toString(),
          year: dt.year.toString(),
        );
        db.addIncome(income);
        incomeAmt.clear();
        incomeDesc.clear();
        Navigator.pop(context, true);
      }
    } else {
      if (_incomeFormKey.currentState.validate() == true) {
        _incomeFormKey.currentState.save();
        income = Income(
          id: editIncome.id,
          description: incomeDesc.text,
          amount: double.parse(incomeAmt.text),
          date: dtFormat.format(dt),
          month: dt.month.toString(),
          year: dt.year.toString(),
        );
        db.updateIncome(income);
        incomeAmt.clear();
        incomeDesc.clear();
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: Color(0xFF31373F),
          appBar: AppBar(
            elevation: 0.0,
            title: Text("Add Income"),
          ),
          body: Container(
            padding: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _incomeFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      _dateFormat.format(dt),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white70),
                      keyboardType: TextInputType.number,
                      controller: incomeAmt,
                      validator: (data) => incomeAmt.text.length == 0
                          ? 'Please enter amount'
                          : null,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        labelText: "Amount",
                        labelStyle: TextStyle(color: Colors.white70),
                        suffixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.white70,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      style: TextStyle(color: Colors.white70),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      controller: incomeDesc,
                      validator: (data) => incomeDesc.text.length == 0
                          ? 'Please enter description'
                          : null,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        labelText: "Description",
                        labelStyle: TextStyle(color: Colors.white70),
                        suffixIcon: Icon(
                          Icons.receipt,
                          color: Colors.white70,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 16.0, right: 12.0),
                        child: FlatButton(
                          highlightColor: Colors.redAccent,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          onPressed: _saveIncome,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.save_alt,
                                color: Colors.white70,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0, left: 12.0),
                        child: FlatButton(
                          highlightColor: Colors.redAccent,
                          color: Colors.white10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.cancel,
                                color: Colors.white70,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
