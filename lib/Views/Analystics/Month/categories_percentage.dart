import 'package:flutter/material.dart';
import '../../../Views/Analystics/Month/generate_cate_monthly_exp_list.dart';
import '../../../Models/Analystic/categories.dart';
import '../../../Database/expense_db.dart';

class PercentageCategories extends StatefulWidget {
  final List<Categories> cateExpList;
  final DateTime selectedMonth;
  PercentageCategories({this.selectedMonth, this.cateExpList});
  @override
  _PercentageCategoriesState createState() => _PercentageCategoriesState();
}

class _PercentageCategoriesState extends State<PercentageCategories> {
  List<Categories> cateExpList = [];
  DBProvider _dbProvider = DBProvider();
  List<double> percentList = [];
  List<Color> colorList = [
    Color(0xFFFE5F55),
    Color(0xFF52D1DC),
    Color(0xFF8661C1),
    Color(0xFF7097A8),
    Color(0xFF1EA896),
    Color(0xFFF5853F),
    Color(0xFFFFE787),
    Color(0xFF19647E),
  ];
  List<String> categoriesList = [
    "Clothing",
    "Entertainment",
    "Food",
    "Gifts/Donations",
    "Medical/Healthcare",
    "Personal",
    "Transportation",
    "Utilities",
  ];
  List<String> iconList = [
    "Icons/xxxhdpi/clothing.png",
    "Icons/xxxhdpi/entertainment.png",
    "Icons/xxxhdpi/food.png",
    "Icons/xxxhdpi/donations.png",
    "Icons/xxxhdpi/healthcare.png",
    "Icons/xxxhdpi/personal.png",
    "Icons/xxxhdpi/transportation.png",
    "Icons/xxxhdpi/utilities.png",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: FutureBuilder(
          future: _dbProvider.getEachCatMonthExp(
            widget.selectedMonth.month.toString(),
            widget.selectedMonth.year.toString(),
          ),
          builder: (context, snapshot) {
            var percentList = [];
            var totalExp = 0.0;
            var onePercent = 0.0;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              );
            } else {
              for (var item in snapshot.data) {
                totalExp = 0.0;
                for (var cateExp in snapshot.data) {
                  totalExp += cateExp.totalAmt;
                }
                onePercent = totalExp / 100;
                percentList.add(item.totalAmt / onePercent);
              }
              return ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        generateReport(widget.selectedMonth,
                            categoriesList[index], context, colorList[index]);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorList[index],
                          child: Image.asset(
                            iconList[index],
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(categoriesList[index]),
                        subtitle: Text("Total Expense"),
                        trailing: Text(
                          percentList[index].toString() == "NaN"
                              ? "0.0 %"
                              : percentList[index].toStringAsFixed(2) + " %",
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
