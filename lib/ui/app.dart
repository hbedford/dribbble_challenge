import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/shots/newshot/new_shot_screen.dart';
import 'package:dribbble_challenge/ui/screens/loading/loading_screen.dart';
import 'package:dribbble_challenge/ui/screens/shots/shot_screen.dart';

class App extends StatelessWidget {
  ThemeData themeData() => ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
            headline1: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.blue,
              fontSize: 28.0,
            ),
            headline2: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w400),
            bodyText1: TextStyle()),
      );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData(),
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/shot': (context) => ShotScreen(),
        '/newshot': (context) => NewShotScreen(),
      },
    );
  }
}
