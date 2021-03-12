import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/infra/repositories/add_shots_repository.dart';
import 'package:dribbble_challenge/infra/repositories/fetch_shots_repository.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:dribbble_challenge/ui/screens/shots/shot_controller.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  ValueNotifier<List<Shot>> list = ValueNotifier<List<Shot>>(null);
  HomeController();
  changeShots(List<Shot> value) => list.value = value;
  Future loadShots(BuildContext context) async {
    List<Shot> value = await GetShotsFromRemote().fetch();
    if (value != null) {
      await AddShotsDatabase().addAll(value);
      changeShots(await GetShotsDatabase().fetch());
    } else {
      if (list.value == null || list.value.length == 0) {
        changeShots(await GetShotsDatabase().fetch());
      }
      Flushbar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        title: 'Ops, houve um problema',
        message: 'Certifique que sua conexão esteja estavel.',
      ).show(context);
    }
  }

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
        loadShots(context);
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
}
