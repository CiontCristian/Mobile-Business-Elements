
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Game.dart';

class DBUtils{

  DBUtils();

  static Future<Database> initDB() async {

    WidgetsFlutterBinding.ensureInitialized();

    final Future<Database> database = openDatabase( join(await getDatabasesPath(), 'wishlist.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE game(id INTEGER PRIMARY KEY autoincrement, title TEXT not null, developer TEXT not null, price REAL not null, rating REAL not null, genre TEXT not null, pegi18 TEXT not null)"
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<int> insertGame(Game game) async {
    final Database db = await DBUtils.initDB();

    return await db.insert(
      'game',
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  static Future<List<Game>> findAll() async {
    final Database db = await DBUtils.initDB();

    final List<Map<String, dynamic>> wishlistMap = await db.query('game');

    return List.generate(wishlistMap.length, (i) {
      Game game = Game(wishlistMap[i]['id'], wishlistMap[i]['title'], wishlistMap[i]['developer'], wishlistMap[i]['price'], wishlistMap[i]['rating'], wishlistMap[i]['genre'], wishlistMap[i]['pegi18']);
      return game;
    });
  }

  static Future<void> updateGame(Game game) async {
    final db = await DBUtils.initDB();

    await db.update(
      'game',
      game.toMap(),
      where: "id = ?",
      whereArgs: [game.id],
    );
  }

  static Future<void> deleteGame(int id) async {
    final db = await DBUtils.initDB();

    await db.delete(
      'game',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}