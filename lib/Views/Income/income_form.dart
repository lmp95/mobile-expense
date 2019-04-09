import 'package:flutter/material.dart';
import '../../Database/expense_db.dart';
import '../../Models/Income/income.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class IncomeForm extends StatefulWidget {
  final DateTime dt;
  final Income editIncome;
  IncomeForm({this.dt, this.editIncome});
  @override
  _IncomeFormState createState() =>
      _IncomeFormState(dt: dt, editIncome: editIncome);
}

class _IncomeFormState extends State<IncomeForm> {
  final DateTime dt;
  final Income editIncome;
  _IncomeFormState({this.dt, this.editIncome});
  TextEditingController incomeAmt = TextEditingController();
  TextEditingController incomeDesc = TextEditingController();
  final _incomeFormKey = GlobalKey<FormState>();
  DBProvider db = DBProvider();
  DateTime currentDate;
  Income income;
  DateFormat dtFormat = DateFormat("yyyy-MM-dd");
  DateFormat _dateFormat = DateFormat("dd MMM yyyy");

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));
    if (picked != null) setState(() => currentDate = picked);
  }

  initState() {
    super.initState();
    currentDate = dt;
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
          date: dtFormat.format(currentDate),
          month: currentDate.month.toString(),
          year: currentDate.year.toString(),
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
          date: dtFormat.format(currentDate),
          month: currentDate.month.toString(),
          year: currentDate.year.toString(),
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
    var device = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: Color(0xFF31373F),
          appBar: AppBar(
            elevation: 0.0,
            title: Text("Add Income"),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _incomeFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dateFormat.format(currentDate),
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: device.longestSide > 600 ? 18.0 : 16.0),
                        ),
                        IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.date_range,
                            color: Colors.white70,
                          ),
                          onPressed: _selectDate,
                        )
                      ],
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
                        labelStyle: TextStyle(
                          color: Colors.white70,
                        ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 16.0, right: 12.0),
                        child: FlatButton(
                          highlightColor: Colors.redAccent,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
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
                            borderRadius: BorderRadius.circular(5.0),
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
