import 'dart:convert';

import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/database/database_helper.dart';
import 'package:dribbble_challenge/infra/http/http_adapter.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:http/http.dart';
import 'dart:io' as Io;
import '../injections.dart';

abstract class FetchShotsRepository {
  Future<List<Shot>> fetch();
}

class GetShotsDatabase extends FetchShotsRepository {
  fetch() async {
    final dbHelper = DatabaseHelper.instance;
    List<Map> list = await dbHelper.getShots();
    return list.map((shot) => Shot.fromMap(shot)).toList();
  }
}

class GetShotsFromRemote extends FetchShotsRepository {
  fetch() async {
    final controller = injection.get<LoginController>();
    HttpAdapter httpClient = HttpAdapter(Client());

    try {
      var res = await httpClient.request(
        url:
            'https://api.dribbble.com/v2/user/shots?access_token=${controller.token}',
        method: 'get',
      );
      return res == null
          ? null
          : res.map<Shot>((shot) => Shot.fromJson(shot)).toList();
    } catch (e) {
      return null;
    }
  }
}

class GetShotsWaitingDatabase extends FetchShotsRepository {
  fetch() async {
    final dbHelper = DatabaseHelper.instance;
    List<Map> list = await dbHelper.getShots();
    List<Shot> shots = [];
    list.map((shot) async {
      final decode = base64Decode(shot['image']);
      var file = Io.File('image.jpg');
      await file.writeAsBytes(decode);
      Shot newShot = Shot.fromMap(shot);
      newShot.addImageFile(file);
      newShot.image = null;
      shots.add(newShot);
    }).toList();
    return shots;
  }
}
