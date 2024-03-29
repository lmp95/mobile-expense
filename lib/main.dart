import 'package:flutter/material.dart';
import 'Views/SplashScreen/splash_screen.dart';
import 'Views/LandingPage/landing_page.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        title: "Expenager",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Play',
          primaryColor: Color(0xFF31373F),
          primarySwatch: Colors.red,
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/LandingPage': (BuildContext context) => LandingPage(),
        });
  }
}
