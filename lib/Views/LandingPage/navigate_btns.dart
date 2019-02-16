import 'package:flutter/material.dart';
import '../../Views/ExpenseHistory/history.dart';

class NavigateBtn extends StatefulWidget {
  final orientation;
  final actualHeight;
  NavigateBtn({this.orientation, this.actualHeight});
  @override
  _NavigateBtnState createState() =>
      _NavigateBtnState(orientation: orientation, actualHeight: actualHeight);
}

class _NavigateBtnState extends State<NavigateBtn> {
  final orientation;
  final actualHeight;
  _NavigateBtnState({this.orientation, this.actualHeight});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: actualHeight / 5,
      child: Row(
        children: <Widget>[
          Container(
            width: (device.width / 2) - 16.0,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.redAccent),
            child: FlatButton(
              onPressed: () {},
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0),
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      maxRadius: 36.0,
                      child: Icon(
                        Icons.show_chart,
                        size: 56.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16.0, right: 16.0),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Analytics",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  width: (device.width / 2) - 16.0,
                  height: ((actualHeight / 5) / 2) - 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF38C8DD)),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => History(
                                    initialDate: DateTime.now(),
                                  )));
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 12.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: Icon(
                              Icons.money_off,
                              size: 32.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            "Expense",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4.0),
                  width: (device.width / 2) - 16.0,
                  height: ((actualHeight / 5) / 2) - 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF7D60BE)),
                  child: FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 12.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: Icon(
                              Icons.attach_money,
                              size: 32.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            "Income",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
