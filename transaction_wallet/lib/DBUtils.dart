
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/Operation.dart';
import 'model/TransactionObj.dart';

class DBUtils{

  DBUtils();

  static Future<Database> initDB() async {

    WidgetsFlutterBinding.ensureInitialized();

    final Future<Database> database = openDatabase( join(await getDatabasesPath(), 'wallet.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE transactiontable(id INTEGER PRIMARY KEY autoincrement, recipient TEXT not null, amount REAL not null, currency TEXT not null)"
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async{
        await db.execute("CREATE TABLE IF NOT EXISTS queue(id INTEGER PRIMARY KEY autoincrement, action TEXT not null, tid INTEGER, FOREIGN KEY(tid) REFERENCES transactiontable(id))");
      },

      version: 4,
    );
    return database;
  }

  static Future<int> insertTransaction(TransactionObj transaction) async {
    final Database db = await DBUtils.initDB();

    return await db.insert(
      'transactiontable',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  static Future<int> insertOperation(Operation operation) async{
    final Database db = await DBUtils.initDB();

    return await db.insert(
      'queue',
      operation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  static Future<List<TransactionObj>> findAll() async {
    final Database db = await DBUtils.initDB();

    final List<Map<String, dynamic>> transactionsMap = await db.query('transactiontable');

    return List.generate(transactionsMap.length, (i) {
      TransactionObj transaction = TransactionObj(transactionsMap[i]['id'], transactionsMap[i]['recipient'], transactionsMap[i]['amount'], transactionsMap[i]['currency']);
      return transaction;
    });
  }

  static Future<List<Operation>> findAllOperations() async {
    final Database db = await DBUtils.initDB();

    final List<Map<String, dynamic>> operationsMap = await db.query('queue');

    return List.generate(operationsMap.length, (i) {
      Operation operation = Operation(operationsMap[i]['id'], operationsMap[i]['action'], operationsMap[i]['tid']);
      return operation;
    });
  }

  static Future<List<Operation>> findOperationByTid(int tid) async {
    final Database db = await DBUtils.initDB();

    final List<Map<String, dynamic>> operationsMap = await db.rawQuery('select * from queue where tid = $tid');

    return List.generate(operationsMap.length, (i) {
      Operation operation = Operation(operationsMap[i]['id'], operationsMap[i]['action'], operationsMap[i]['tid']);
      return operation;
    });
  }

  static Future<List<TransactionObj>> findAllUnsynchronized() async{
    final Database db = await DBUtils.initDB();

    final List<Map<String, dynamic>> transactionsMap = await db.rawQuery("SELECT transactiontable.id, transactiontable.recipient, transactiontable.amount, transactiontable.currency FROM transactiontable INNER JOIN queue ON queue.tid = transactiontable.id");

    return List.generate(transactionsMap.length, (i) {
      TransactionObj transaction = TransactionObj(transactionsMap[i]['id'], transactionsMap[i]['recipient'], transactionsMap[i]['amount'], transactionsMap[i]['currency']);
      return transaction;
    });
  }

  static Future<void> deleteTransaction(int id) async {
    final db = await DBUtils.initDB();

    await db.delete(
      'transactiontable',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<void> deleteOperation(int id) async {
    final db = await DBUtils.initDB();

    await db.delete(
      'queue',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}