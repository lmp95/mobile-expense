import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _logoOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 500);
    return new Timer(_duration, setOpacity);
  }

  void setOpacity() {
    setState(() {
      _logoOpacity = 1.0;
      _routeToLandingPage();
    });
  }

  _routeToLandingPage() async {
    var _duration = new Duration(milliseconds: 1500);
    return new Timer(_duration, _landingPageRoute);
  }

  void _landingPageRoute() {
    Navigator.pushReplacementNamed(context, '/LandingPage');
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: device.height,
        width: device.width,
        decoration: BoxDecoration(
          color: Color(0xFF31373F),
        ),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 1000),
          opacity: _logoOpacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: device.height / 3,
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFF5F5F5),
                    radius: 48.0,
                    child: Icon(
                      Icons.attach_money,
                      color: Colors.red,
                      size: 90.0,
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Expenager".toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                width: device.width / 4,
                height: 1.5,
                color: Colors.white,
              ),
              Container(
                child: Text(
                  "Track your daily expense with Expenager",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
