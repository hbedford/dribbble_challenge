import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/database/database_helper.dart';

class AddToDatabase {
  addAll(List<Shot> shots) async {
    final database = DatabaseHelper.instance;
    await database.removeAllShots();
    List<Shot> list = [];
    for (Shot shot in shots) {
      await shot.fileFromImageUrl();
      list.add(shot);
    }
    print('1');
    await database.insertAllShots(list.map((e) => e.toMap).toList());
  }

  Future<bool> add(Shot shot) async {
    final dbHelper = DatabaseHelper.instance;
    int value = await dbHelper.insertShot(shot.toMap);
    return value != 0;
  }

  Future<bool> addWaiting(Shot shot) async {
    final dbHelper = DatabaseHelper.instance;
    int value =
        await dbHelper.insertShotWaiting(Map<String, dynamic>.from(shot.toMap));
    return value != 0;
  }
}
