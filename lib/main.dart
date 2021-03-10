import 'package:dribbble_challenge/ui/app.dart';
import 'package:flutter/cupertino.dart';

import 'infra/injections.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjection();
  runApp(App());
}
