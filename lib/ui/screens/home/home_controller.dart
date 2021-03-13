import 'package:dribbble_challenge/data/cache/use/cases/add_to_database.dart';
import 'package:dribbble_challenge/data/cache/use/cases/get_from_database.dart';
import 'package:dribbble_challenge/data/remote/usecases/get_from_remote.dart';
import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:dribbble_challenge/ui/screens/shots/shot_controller.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  ValueNotifier<List<Shot>> list = ValueNotifier<List<Shot>>(null);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  HomeController();
  changeShots(List<Shot> value) => list.value = value;

  changeIsLoading(bool value) => isLoading.value = value;
  goToNewShot(BuildContext context) {
    final controller = injection.get<ShotController>();
    controller.changeShot(Shot());
    Navigator.pushNamed(context, '/newshot').then((value) {
      if (value) {
        Flushbar(
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 4),
          title: 'Enviado com sucesso',
          message: 'O shot foi adicionado!!',
        ).show(context);
        Future.delayed(Duration(seconds: 2), () {
          getShots(context);
        });
      }
    });
  }

  logout(BuildContext context) async {
    final controller = injection.get<LoginController>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    controller.token = null;
    controller.changeLoading(false);

    Navigator.pushReplacementNamed(context, '/login');
  }

  Future getShots(BuildContext context) async {
    List<Shot> shots;
    changeIsLoading(true);

    shots = await GetFromRemote().fetch();
    if (shots != null) {
      await AddToDatabase().addAll(shots);
    } else {
      Flushbar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        title: 'Ops, houve um problema',
        message: 'Certifique que sua conexão esteja estavel.',
      ).show(context);
    }
    await getShotsFromDatabase();
    changeIsLoading(false);

    return null;
  }

  Future getShotsFromDatabase() async {
    List<Shot> list = await GetFromDatabase().getList();

    changeShots(list);
  }
}
