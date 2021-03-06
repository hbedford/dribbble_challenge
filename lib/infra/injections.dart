import 'package:dribbble_challenge/ui/screens/home/home_controller.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:dribbble_challenge/ui/screens/shots/shot_controller.dart';
import 'package:get_it/get_it.dart';

final GetIt injection = GetIt.I;
Future<void> setupInjection() async {
  injection.registerSingleton<LoginController>(LoginController());
  injection.registerSingleton<HomeController>(HomeController());
  injection.registerSingleton<ShotController>(ShotController());
}
