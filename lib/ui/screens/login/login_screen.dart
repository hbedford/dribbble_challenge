import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final controller = injection.get<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text('Entrar'.toUpperCase()),
                    onPressed: controller.login,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
