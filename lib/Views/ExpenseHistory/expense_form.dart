import 'package:flutter/material.dart';
import '../../Database/expense_db.dart';
import '../../Models/Expense/expense.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  final selectedDate;
  final Expense expense;
  ExpenseForm({this.selectedDate, this.expense});
  @override
  _ExpenseFormState createState() =>
      _ExpenseFormState(selectedDate: selectedDate, expense: expense);
}

class _ExpenseFormState extends State<ExpenseForm> {
  final selectedDate;
  final Expense expense;
  _ExpenseFormState({this.selectedDate, this.expense});
  final _expAddFormKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController item = TextEditingController();
  DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  String choiceCate;
  var error = false;
  List<String> _cateList = [
    'Clothing',
    'Entertainment',
    'Food',
    'Gifts/Donations',
    'Medical/Healthcare',
    'Personal',
    'Transportation',
    'Utilities',
  ];

  @override
  void initState() {
    super.initState();
    if (expense != null) {
      setState(() {
        amount.text = expense.amount.toString();
        item.text = expense.item;
        choiceCate = expense.category;
      });
    }
  }

  _setCate(String value) {
    setState(() {
      choiceCate = value;
    });
  }

  _saveExpense() {
    if (expense != null) {
      if (_expAddFormKey.currentState.validate() == false &&
          choiceCate == null) {
        setState(() {
          error = true;
        });
      } else if (_expAddFormKey.currentState.validate() == true &&
          choiceCate == null) {
        setState(() {
          error = true;
        });
      } else if (_expAddFormKey.currentState.validate() == false &&
          choiceCate != null) {
        setState(() {
          error = false;
        });
      } else {
        setState(() {
          error = false;
        });
        _expAddFormKey.currentState.save();
        var db = DBProvider();
        var exp = Expense();
        exp.id = expense.id;
        exp.item = item.text;
        exp.amount = double.parse(amount.text);
        exp.category = choiceCate;
        exp.date = _dateFormat.parse(selectedDate).toString().substring(
            0, _dateFormat.parse(selectedDate).toString().indexOf(' '));
        exp.month = _dateFormat.parse(selectedDate).month.toString();
        exp.year = _dateFormat.parse(selectedDate).year.toString();
        db.updateExpense(exp);
        Navigator.pop(context);
      }
    } else {
      if (_expAddFormKey.currentState.validate() == false &&
          choiceCate == null) {
        setState(() {
          error = true;
        });
      } else if (_expAddFormKey.currentState.validate() == true &&
          choiceCate == null) {
        setState(() {
          error = true;
        });
      } else if (_expAddFormKey.currentState.validate() == false &&
          choiceCate != null) {
        setState(() {
          error = false;
        });
      } else {
        setState(() {
          error = false;
        });
        _expAddFormKey.currentState.save();
        var db = DBProvider();
        var expense = Expense();
        expense.item = item.text;
        expense.amount = double.parse(amount.text);
        expense.category = choiceCate;
        expense.date = _dateFormat.parse(selectedDate).toString().substring(
            0, _dateFormat.parse(selectedDate).toString().indexOf(' '));
        expense.month = _dateFormat.parse(selectedDate).month.toString();
        expense.year = _dateFormat.parse(selectedDate).year.toString();
        db.addExpense(expense);
        Navigator.pop(context);
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
            title: Text(
              "Add Expense",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _expAddFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        selectedDate,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: device.longestSide > 600 ? 18.0 : 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextFormField(
                        controller: item,
                        validator: (data) => item.text.length == 0
                            ? 'Please enter description'
                            : null,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.white70),
                        textCapitalization: TextCapitalization.words,
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white70),
                        keyboardType: TextInputType.number,
                        controller: amount,
                        validator: (data) => amount.text.length == 0
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
                            Icons.monetization_on,
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
                    InputDecorator(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                        errorText:
                            error == true ? 'Please choose Category' : null,
                        contentPadding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: Color(0xFF31373F),
                            brightness: Brightness.dark),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text(
                              'Category',
                              style: TextStyle(color: Colors.white70),
                            ),
                            style: TextStyle(color: Colors.white70),
                            value: choiceCate,
                            items: _cateList.map((String value) {
                              return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ));
                            }).toList(),
                            onChanged: (value) => _setCate(value),
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
                            onPressed: _saveExpense,
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
          ),
        );
      },
    );
  }
}
