import 'package:dribbble_challenge/ui/screens/loading/loading_screen.dart';
import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';

class App extends StatelessWidget {
  ThemeData themeData() => ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.blue,
            fontSize: 28.0,
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData(),
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen()
      },
    );
  }
}
