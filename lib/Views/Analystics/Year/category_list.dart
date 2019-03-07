import 'package:flutter/material.dart';

class YearlyCategoryList extends StatefulWidget {
  @override
  _YearlyCategoryListState createState() => _YearlyCategoryListState();
}

class _YearlyCategoryListState extends State<YearlyCategoryList> {
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
                padding: EdgeInsets.only(top: 8.0),
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
              Container(
                padding: EdgeInsets.only(top: 8.0),
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
              Container(
                padding: EdgeInsets.only(top: 8.0),
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
              Container(
                padding: EdgeInsets.only(top: 8.0),
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
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 8.0),
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
              Container(
                padding: EdgeInsets.only(top: 8.0),
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
              Container(
                padding: EdgeInsets.only(top: 8.0),
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
              Container(
                padding: EdgeInsets.only(top: 8.0),
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
            ],
          ),
        ],
      ),
    );
  }
}
