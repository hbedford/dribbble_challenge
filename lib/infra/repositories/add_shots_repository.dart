import 'dart:convert';

import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/database/database_helper.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injections.dart';

abstract class AddShotRepository {
  Future<bool> add(Shot shot);
}

class AddShotRemote extends AddShotRepository {
  Future<bool> add(Shot shot) async {
    final controller = injection.get<LoginController>();
    var uri = Uri.parse("https://api.dribbble.com/v2/shots");
    var request = new MultipartRequest("POST", uri);
    var multipartFile = await MultipartFile.fromPath(
        "image", shot.file.value.path,
        contentType: MediaType('image',
            shot.isJpg ? 'jpeg' : shot.file.value.path.split('.').last));
    request.files.add(multipartFile);
    request.fields.addAll(Map.from(shot.toJson));
    request.fields.removeWhere((key, value) => value == null);
    request.headers['Authorization'] = 'Bearer ${controller.token}';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      StreamedResponse response = await request.send();
      prefs.setBool('lostConnection', false);
      return response.reasonPhrase == 'Accepted';
    } catch (e) {
      prefs.setBool('lostConnection', true);
      return false;
    }
  }
}

class AddShotDatabase extends AddShotRepository {
  Future<bool> add(Shot shot) async {
    final dbHelper = DatabaseHelper.instance;
    int value = await dbHelper.insertShot(await shot.toMap);
    return value != 0;
  }
}

class AddShotWaitingDatabase extends AddShotRepository {
  Future<bool> add(Shot shot) async {
    final dbHelper = DatabaseHelper.instance;
    int value = await dbHelper
        .insertShotWaiting(Map<String, dynamic>.from(await shot.toMap));
    return value != 0;
  }
}

class AddShotsDatabase {
  Future<void> addAll(List<Shot> shots) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.removeAllShots();
    List<Map<String, dynamic>> list = [];
    shots.forEach((element) async {
      Map<String, dynamic> map = await element.toMap;
      list.add(map);
    });
    await dbHelper.insertAllShots(list);
  }
}
