import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final controller = injection.get<LoginController>();

  @override
  Widget build(BuildContext context) {
    controller.changeContext(context);
    Future.delayed(Duration(seconds: 1), () {
      controller.loadToken();
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Simple Dribbble',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
