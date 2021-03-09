import 'package:flutter/material.dart';

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
      initialRoute: '/login',
      routes: {'/login': (context) => LoginScreen()},
    );
  }
}
