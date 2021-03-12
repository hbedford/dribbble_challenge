import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "dribbble.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        create table shots ( 
          id integer primary key autoincrement, 
          remoteid integer,
          title text not null,
          description text,
          image text not null)
        ''');
    await db.execute('''
        create table shotswaiting ( 
          id integer primary key autoincrement,
          remoteid integer, 
          title text not null,
          description text,
          image text not null)
        ''');
  }

  Future<int> insertShot(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('shots', row);
  }

  Future<int> insertAllShots(List<Map<String, dynamic>> list) async {
    Database db = await instance.database;
    list.forEach((element) async {
      await db.insert('shots', element);
    });
    return null;
  }

  Future<int> insertShotWaiting(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('shotswaiting', row);
  }

  Future<List<Map<String, dynamic>>> getShots() async {
    Database db = await instance.database;
    return await db.query('shots');
  }

  Future<bool> removeWaitingShot(int id) async {
    Database db = await instance.database;
    return await db.delete('shotswaiting', where: 'id= ?', whereArgs: [id]) ==
        1;
  }

  Future<bool> removeAllShots() async {
    Database db = await instance.database;
    await db.execute('DELETE  FROM shots');
    return true;
  }
}
