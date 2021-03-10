import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/http/http_adapter.dart';
import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:dribbble_challenge/ui/screens/shots/shot_controller.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class HomeController {
  ValueNotifier<List<Shot>> list = ValueNotifier<List<Shot>>([]);
  HomeController();
  Future getShots() async {
    final controller = GetIt.I.get<LoginController>();
    HttpAdapter httpClient = HttpAdapter(Client());

    try {
      var res = await httpClient.request(
        url:
            'https://api.dribbble.com/v2/user/shots?access_token=${controller.token}',
        method: 'get',
      );
      return res;
    } catch (e) {
      return null;
    }
  }

  Future loadShots(BuildContext context) async {
    List value = await getShots();
    if (value != null) {
      list.value = value.map((image) => Shot.fromJson(image)).toList();
    } else {
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
    Navigator.pushNamed(context, '/newshot');
  }
}
