import 'package:dribbble_challenge/infra/database/database_helper.dart';

class RemoveShotWaitingFromDatabase {
  Future<bool> remove(int id) async {
    DatabaseHelper db = DatabaseHelper.instance;
    return await db.removeWaitingShot(id);
  }
}

class RemoveShotsFromDatabase {
  Future<bool> removeAll() async {
    DatabaseHelper db = DatabaseHelper.instance;
    return await db.removeAllShots();
  }
}
