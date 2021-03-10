import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/http/http_adapter.dart';
import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:dribbble_challenge/ui/screens/shots/shot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class HomeController {
  ValueNotifier<List<Shot>> list = ValueNotifier<List<Shot>>([]);
  HomeController();
  Future getShots() async {
    final controller = GetIt.I.get<LoginController>();
    HttpAdapter httpClient = HttpAdapter(Client());

    var res = await httpClient.request(
      url:
          'https://api.dribbble.com/v2/user/shots?access_token=${controller.token}',
      method: 'get',
    );
    return res;
  }

  Future loadShots() async {
    List value = await getShots();
    list.value = value.map((image) => Shot.fromJson(image)).toList();
  }

  goToNewShot(BuildContext context) {
    final controller = injection.get<ShotController>();
    controller.changeShot(Shot());
    Navigator.pushNamed(context, '/newshot');
  }
}
