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
    var _duration = new Duration(milliseconds: 1300);
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
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.3, 0.75, 0.9],
            colors: [
              Color(0xFFFF8050),
              Color(0xFFFF764F),
              Colors.redAccent,
              Colors.red,
            ],
          ),
        ),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: _logoOpacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: device.height / 3,
                child: Container(
                    child: Image.asset(
                  "Icons/xxxhdpi/app_logo.png",
                  color: Color(0xFFFFFFFF),
                )),
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
