import 'package:flutter/material.dart';
import '../../Analystics/Year/year_exp_list.dart';

class YearlyCategoryList extends StatefulWidget {
  final String selectedYear;
  YearlyCategoryList({this.selectedYear});
  @override
  _YearlyCategoryListState createState() =>
      _YearlyCategoryListState(selectedYear: selectedYear);
}

class _YearlyCategoryListState extends State<YearlyCategoryList> {
  final String selectedYear;
  _YearlyCategoryListState({this.selectedYear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.0),
                width: 135.0,
                height: 20.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showYearExpList(
                        context, "Clothing", Color(0xFFFE5F55), selectedYear);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFFFE5F55),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Clothing",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.0),
                width: 135.0,
                height: 20.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showYearExpList(context, "Entertainment", Color(0xFF52D1DC),
                        selectedYear);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFF52D1DC),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Entertainment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 135.0,
                height: 20.0,
                margin: EdgeInsets.symmetric(vertical: 2.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showYearExpList(
                        context, "Food", Color(0xFF8661C1), selectedYear);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFF8661C1),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Food",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 135.0,
                height: 20.0,
                margin: EdgeInsets.symmetric(vertical: 2.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showYearExpList(context, "Gifts/Donations",
                        Color(0xFF7097A8), selectedYear);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFF7097A8),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Gifts/Donations",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 135.0,
                height: 20.0,
                margin: EdgeInsets.symmetric(vertical: 2.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showYearExpList(context, "Medical/Healthcare",
                        Color(0xFF1EA896), selectedYear);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFF1EA896),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Medical/Healthcare",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 135.0,
                height: 20.0,
                margin: EdgeInsets.symmetric(vertical: 2.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showYearExpList(
                        context, "Personal", Color(0xFFF5853F), selectedYear);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFFF5853F),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Personal",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 135.0,
                height: 20.0,
                margin: EdgeInsets.symmetric(vertical: 2.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showYearExpList(context, "Transportation",
                        Color(0xFFFFE787), selectedYear);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFFFFE787),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Transportation",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 135.0,
                height: 20.0,
                margin: EdgeInsets.symmetric(vertical: 2.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    showYearExpList(
                        context, "Utilities", Color(0xFF19647E), selectedYear);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFF19647E),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Utilities",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      )
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
