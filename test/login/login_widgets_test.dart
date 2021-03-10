import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var loginPage;
  var buttonLogin;
  setUpAll(() async {
    setupInjection();
    loginPage = MaterialApp(
      home: LoginScreen(),
    );
    buttonLogin = find.text('Entrar'.toUpperCase());
  });
  testWidgets(
      'Ensure the LoginScreen start with Button Enter on and CircularProgressive Off',
      (WidgetTester tester) async {
    await tester.pumpWidget(loginPage);

    expect(buttonLogin, findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
