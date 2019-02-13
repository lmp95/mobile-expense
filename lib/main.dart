import 'package:flutter/material.dart';
import 'Views/SplashScreen/splash_screen.dart';
import 'Views/LandingPage/landing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Play',
          primaryColor: Color(0xFF242424),
          primarySwatch: Colors.red,
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/LandingPage': (BuildContext context) => LandingPage(),
        });
  }
}
