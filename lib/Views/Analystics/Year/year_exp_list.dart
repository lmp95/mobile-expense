import 'package:flutter/material.dart';
import '../../../Database/expense_db.dart';
import '../../../Models/Expense/expense.dart';

DBProvider _dbProvider = DBProvider();
RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

void showYearExpList(context, category, color, selectedYear) {
  var iconImg = '';
  if (category == "Clothing") {
    iconImg = "Icons/xxxhdpi/clothing.png";
  } else if (category == "Entertainment") {
    iconImg = "Icons/xxxhdpi/entertainment.png";
  } else if (category == "Food") {
    iconImg = "Icons/xxxhdpi/food.png";
  } else if (category == "Gifts/Donations") {
    iconImg = "Icons/xxxhdpi/donations.png";
  } else if (category == "Medical/Healthcare") {
    iconImg = "Icons/xxxhdpi/healthcare.png";
  } else if (category == "Personal") {
    iconImg = "Icons/xxxhdpi/personal.png";
  } else if (category == "Transportation") {
    iconImg = "Icons/xxxhdpi/transportation.png";
  } else {
    iconImg = "Icons/xxxhdpi/utilities.png";
  }
  showBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          iconImg,
                          height: 24,
                          color: color,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 14.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: _dbProvider.annualCatExpList(selectedYear, category),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length != 0) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation(color),
                          ),
                        );
                      } else {
                        List<Expense> expList = snapshot.data;
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(expList[i].item),
                              subtitle: Text(expList[i].date),
                              trailing: Text(
                                "\$ " +
                                    expList[i]
                                        .amount
                                        .toString()
                                        .replaceAllMapped(reg, mathFunc),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return Center(
                        child: Text("No Expense List"),
                      );
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 50.0),
                color: color,
                child: ListTile(
                  title: Text(
                    "Total",
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  trailing: FutureBuilder(
                    future:
                        _dbProvider.annualCatExpList(selectedYear, category),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data.length != 0) {
                        var dataList = snapshot.data;
                        var totalExp = 0.0;
                        for (var item in dataList) {
                          totalExp += item.amount;
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            "\$ 0.0",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          );
                        } else {
                          return Text(
                            "\$ $totalExp".replaceAllMapped(reg, mathFunc),
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          );
                        }
                      } else {
                        return Text(
                          "\$ 0.0",
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        );
      });
}
