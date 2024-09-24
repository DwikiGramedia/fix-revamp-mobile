import 'dart:io';

import 'package:revamp_eperpus_mobile/model/Product/borrowed_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static final _databaseName = "eperpus.db";
  Future<sql.Database> database() async {
    return await initDatabase();
  }

  Future<sql.Database> initDatabase() async {
    Directory document = await getApplicationDocumentsDirectory();
    String path = join(document.path, _databaseName);
    return sql.openDatabase(path, version: 1, onCreate: onCreate);
  }

  Future<void> onCreate(sql.Database db, int version) async {
    await db.execute('''
    CREATE TABLE book(
    id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    title TEXT NOT NULL,
    returnDate TEXT NOT NULL,
    pathBook TEXT NOT NULL,
    averageRate REAL NOT NULL,
    description TEXT NOT NULL,
    coverImage TEXT NOT NULL,
    company TEXT NOT NULL,
    coverImage TEXT NOT NULL,
    )
    ''');
  }

  Future<int> insert(BorrowedModel data) async {
    final db = await DatabaseHelper().database();
    var id = await db.insert("book", data.toJson());
    return id;
  }

  Future<List<BorrowedModel>> getItems({required String username}) async {
    final db = await DatabaseHelper().database();
    var list =
        await db.query("book", where: "username = ?", whereArgs: [username]);
    List<BorrowedModel> dataList = [];
    var index = 0;
    while (index < list.length) {
      dataList.add(BorrowedModel.fromJson(list[index]));
    }
    return dataList;
  }

  Future<void> deleteByDate() async {
    final db = await DatabaseHelper().database();
    DateTime date = DateTime.now();
    db.delete("book", where: "returnDate = ?", whereArgs: [date]);
  }

  Future<void> deleteById(int id) async {
    final db = await DatabaseHelper().database();
    db.delete("book", where: "id = ?", whereArgs: [id]);
  }
}
