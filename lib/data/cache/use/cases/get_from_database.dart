import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/database/database_helper.dart';

class GetFromDatabase {
  Future<List<Shot>> getList() async {
    final database = DatabaseHelper.instance;

    List list = await database.getShots();
    List<Shot> shots = list.map((e) => Shot.fromMap(e)).toList();
    return shots;
  }
}
