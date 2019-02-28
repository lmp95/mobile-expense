import 'package:flutter/material.dart';

class PercentageCategories extends StatefulWidget {
  @override
  _PercentageCategoriesState createState() => _PercentageCategoriesState();
}

class _PercentageCategoriesState extends State<PercentageCategories> {
  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: device.width / 4,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFFFE5F55),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 8.0),
                          child: Icon(
                            Icons.train,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        ),
                        Text(
                          "11.61%",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
