import 'package:flutter/material.dart';
import '../Week/weekly_modal_dialog.dart';
import '../../../Models/Expense/expense.dart';

class WeeklyCategory extends StatefulWidget {
  final String startDate;
  final String endDate;
  final List<double> amtList;
  final List<List<Expense>> allCatList;
  WeeklyCategory({this.startDate, this.endDate, this.amtList, this.allCatList});
  @override
  _WeeklyCategoryState createState() => _WeeklyCategoryState(
      startDate: startDate,
      endDate: endDate,
      amtList: amtList,
      allCatList: allCatList);
}

class _WeeklyCategoryState extends State<WeeklyCategory> {
  final String startDate;
  final String endDate;
  final List<double> amtList;
  final List<List<Expense>> allCatList;
  _WeeklyCategoryState(
      {this.startDate, this.endDate, this.amtList, this.allCatList});

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 75.0,
                height: 100.0,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showModalSheet(
                        context, allCatList[0], Color(0xFFFE5F55), "Clothing");
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0x98FE5F55),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1.0,
                            color: Color(0xFFFE5F55),
                          ),
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          "Icons/xxxhdpi/clothing.png",
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "\$ " +
                              amtList[0]
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 75.0,
                height: 100.0,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showModalSheet(context, allCatList[1], Color(0xFF52D1DC),
                        "Entertainment");
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0x9852D1DC),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1.0,
                            color: Color(0xFF52D1DC),
                          ),
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          "Icons/xxxhdpi/entertainment.png",
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "\$ " +
                              amtList[1]
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 75.0,
                height: 100.0,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showModalSheet(
                        context, allCatList[2], Color(0xFF8661C1), "Food");
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0x988661C1),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1.0,
                            color: Color(0xFF8661C1),
                          ),
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          "Icons/xxxhdpi/food.png",
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "\$ " +
                              amtList[2]
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 75.0,
                height: 100.0,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showModalSheet(context, allCatList[3], Color(0xFF7097A8),
                        "Gifts/Donations");
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0x987097A8),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1.0,
                            color: Color(0xFF7097A8),
                          ),
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          "Icons/xxxhdpi/donations.png",
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "\$ " +
                              amtList[3]
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 75.0,
                height: 100.0,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showModalSheet(context, allCatList[4], Color(0xFF1EA896),
                        "Medical/Healthcare");
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0x981EA896),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1.0,
                            color: Color(0xFF1EA896),
                          ),
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          "Icons/xxxhdpi/healthcare.png",
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "\$ " +
                              amtList[4]
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 75.0,
                height: 100.0,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showModalSheet(
                        context, allCatList[5], Color(0xFFF5853F), "Personal");
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0x98F5853F),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1.0,
                            color: Color(0xFFF5853F),
                          ),
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          "Icons/xxxhdpi/personal.png",
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "\$ " +
                              amtList[5]
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 75.0,
                height: 100.0,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showModalSheet(context, allCatList[6], Color(0xFFFFE787),
                        "Transportation");
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0x98FFE787),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1.0,
                            color: Color(0xFFFFE787),
                          ),
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          "Icons/xxxhdpi/transportation.png",
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "\$ " +
                              amtList[6]
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 75.0,
                height: 100.0,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showModalSheet(
                        context, allCatList[7], Color(0xFF19647E), "Utilities");
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0x9819647E),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1.0,
                            color: Color(0xFF19647E),
                          ),
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          "Icons/xxxhdpi/utilities.png",
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "\$ " +
                              amtList[7]
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
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
    );
  }
}
