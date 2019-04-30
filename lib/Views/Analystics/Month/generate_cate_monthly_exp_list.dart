import 'package:flutter/material.dart';
import '../../../Database/expense_db.dart';
import '../../../Models/Expense/expense.dart';

DBProvider _dbProvider = DBProvider();
RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

generateReport(DateTime _selectedMonth, String category, BuildContext context,
    Color selectedColor) {
  double finalAmt = 0.0;
  List<Expense> fetchList = [];
  _dbProvider
      .getSpecCateExpList(_selectedMonth.month.toString(),
          _selectedMonth.year.toString(), category)
      .then((data) {
    for (var exp in data) {
      finalAmt += exp.amount;
    }
    fetchList = data;
  });
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          margin: EdgeInsets.only(bottom: 50.0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 24.0),
                alignment: AlignmentDirectional.centerStart,
                height: 50.0,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8.0),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    Text(
                      category,
                      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
                    ),
                  ],
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
                  itemCount: fetchList.length,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListTile(
                        title: Text(fetchList[i].item),
                        subtitle: Text(fetchList[i].date),
                        trailing: Text("\$ " +
                            fetchList[i]
                                .amount
                                .toString()
                                .replaceAllMapped(reg, mathFunc)),
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
                  trailing: Text("\$ " +
                      finalAmt.toString().replaceAllMapped(reg, mathFunc)),
                ),
              ),
            ],
          ),
        );
      });
}
