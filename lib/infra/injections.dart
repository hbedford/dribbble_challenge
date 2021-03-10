import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:get_it/get_it.dart';

final GetIt injection = GetIt.I;
Future<void> setupInjection() async {
  injection.registerSingleton<LoginController>(LoginController());
}
