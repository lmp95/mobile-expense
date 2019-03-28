import 'package:flutter/material.dart';
import '../../../Models/Expense/expense.dart';

double totalAmt = 0.0;
RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

void showModalSheet(
    BuildContext context, List<Expense> expList, Color color, String category) {
  totalAmt = 0.0;
  for (var item in expList) {
    totalAmt += item.amount;
  }
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Container(
              color: color,
              padding: EdgeInsets.all(16.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expList.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(expList[i].item),
                    subtitle: Text(expList[i].date),
                    trailing: Text(expList[i].amount.toString()),
                  );
                },
              ),
            ),
            Container(
                color: color,
                child: ListTile(
                  title: Text(
                    "Total",
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  trailing: Text(
                    "\$ " + totalAmt.toString().replaceAllMapped(reg, mathFunc),
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                ))
          ],
        ),
      );
    },
  );
}
