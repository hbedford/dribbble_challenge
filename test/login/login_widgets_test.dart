import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
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
  testWidgets(
      'Ensure when you click on EnterButton the CircularProgressIndication turn on and Enter Button turn off',
      (WidgetTester tester) async {
    await tester.pumpWidget(loginPage);
    injection.get<LoginController>().changeLoading(true);
    await tester.pump();
    expect(buttonLogin, findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
