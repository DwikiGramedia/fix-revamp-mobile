import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SavedBook {
  int productId;
  int brandId;
  String key;
  String image;
  String title;
  String filePathZip;
  String detailUrl;
  String filePathPDF;
  int userId;
  int? id;
  String fileType;
  String editionCode;
  String date;
  String watermark;
  String company;
  String? expires;

  SavedBook({
    required this.productId,
    required this.brandId,
    required this.key,
    required this.image,
    required this.title,
    required this.filePathZip,
    required this.detailUrl,
    required this.filePathPDF,
    required this.userId,
    this.id,
    required this.fileType,
    required this.editionCode,
    required this.date,
    required this.watermark,
    required this.company,
    this.expires = "2023-12-31 00:00:00.000Z",
  });

  factory SavedBook.mapJson(Map<String, dynamic> json) {
    return SavedBook(
      productId: json["productId"],
      brandId: json["brandId"],
      key: json["key"],
      image: json["image"],
      title: json["title"],
      filePathZip: json["filePathZip"],
      detailUrl: json["detailUrl"],
      filePathPDF: json["filePathPDF"],
      userId: json["userId"],
      id: getJsonValueAsInt(json, "id"),
      fileType: getJsonValueAsString(json, "fileType"),
      editionCode: json["editionCode"],
      date: json["date"],
      watermark: json["watermark"],
      company: json["company"],
      expires: json["expires"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "detailUrl": detailUrl,
      "filePathZip": filePathZip,
      "productId": productId,
      "filePathPDF": filePathPDF,
      "brandId": brandId,
      "key": key,
      "userId": userId,
      "fileType": fileType,
      "editionCode": editionCode,
      "date": date,
      "watermark": watermark,
      "company": company,
      "expires": expires
    };
  }
}

class DatabaseHelper {
  Future<Database> initializeDb() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'book.db'),
        onCreate: (database, version) async {
      await database.execute("CREATE TABLE book("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT NOT NULL,"
          "productId INTEGER NOT NULL,"
          "detailUrl TEXT NOT NULL,"
          "image TEXT NOT NULL,"
          "filePathZip TEXT NOT NULL,"
          "filePathPDF TEXT NOT NULL,"
          "brandId INTEGER NOT NULL,"
          "key TEXT NOT NULL,"
          "userId INTEGER NOT NULL,"
          "fileType TEXT NOT NULL,"
          "editionCode TEXT NOT NULL,"
          "date TEXT NOT NULL,"
          "watermark TEXT NOT NULL,"
          "company TEXT NOT NULL,"
          "expires TEXT NOT NULL)");
    }, version: 1);
  }

  Future<void> insertBook(SavedBook book) async {
    try {
      final Database db = await initializeDb();
      final SavedBook? savedBook = await getBook(book.productId);
      if (savedBook == null) {
        await db.insert('book', book.toJson());
      } else {
        await updateBook(book, book.productId);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateBook(SavedBook book, int productId) async {
    try {
      final Database db = await initializeDb();
      await db.update(
        'book',
        book.toJson(),
        where: 'productId = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      await debugLog("Error updateBook: $e");
    }
  }

  Future<SavedBook?> getBook(int productId) async {
    final Database db = await initializeDb();
    final List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT * FROM book WHERE productId=?", [productId]);
    if (result.isEmpty) {
      return null;
    } else {
      var savedBook = result.map((e) => SavedBook.mapJson(e)).toList().first;
      return savedBook;
    }
  }

  Future<List<SavedBook>> getBooks() async {
    final Database db = await initializeDb();
    final List<Map<String, dynamic>> result = await db.query("book");
    return result.map((e) => SavedBook.mapJson(e)).toList();
  }

  Future<void> deleteBook(int productId) async {
    final db = await initializeDb();
    await debugLog("product id: $productId");
    await db.delete("book", where: "productId = ?", whereArgs: [productId]);
  }

  Future<void> clearBook() async {
    final db = await initializeDb();
    await db.delete("book");
  }
}
