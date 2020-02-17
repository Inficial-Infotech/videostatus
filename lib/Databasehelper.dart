import 'dart:async';
import 'dart:io';


import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableUser = "favorite";
  final String columnId = "id";
  final String youtubeid="youtubeid";
  final String image="image";
  final String title="title";
  final String tableUser2 = "Caching";
  final String columnId2 = "id";
  final String base64="base64";
  final String path="path";
  final String imagename="imagename";


  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentDirectory.path, "favorite.db"); //home://directory/files/maindb.db

    var ourDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return ourDb;
  }

  /*
     id | username | password
     ------------------------
     1  | Paulo    | paulo
     2  | James    | bond
   */

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $youtubeid TEXT, $image TEXT, $title TEXT)");
    await db.execute(
         "CREATE TABLE $tableUser2($columnId2 INTEGER PRIMARY KEY, $base64 TEXT, $path TEXT,$imagename TEXT)");}

  //CRUD - CREATE, READ, UPDATE , DELETE

  //Insertion
  Future<int> saveUser(String user,String image,String title) async {
    var dbClient = await db;
    var map={
      "youtubeid":user,
      "image":image,
      "title":title,
    };
    int res = await dbClient.insert("$tableUser", map);
    return res;

  }

  //Insertion
  Future<int> saveimage(String base64,String path,String imagename) async {
    var dbClient = await db;
    var map={
      "base64":base64,
      "path":path,
      "imagename":imagename

    };
    int res = await dbClient.insert("$tableUser2", map);
    return res;

  }

  //Get Users
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser ORDER BY $columnId DESC");
//    for(var i=0;i<result.)
    return result.toList();
  }

  //Get Users
  Future<List> getAllimage() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser2 ORDER BY $columnId2 DESC");

    return result.toList();
  }

  Future<int> getCount(String data) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser WHERE $youtubeid='$data'"));
  }

//  Future<User> getUser(int id) async {
//    var dbClient = await db;
//
//    var result = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $columnId = $id");
//    if (result.length == 0) return null;
//    return new User.fromMap(result.first);
//  }

  Future<int> deleteUser(String id) async {
    var dbClient = await db;

    return await dbClient.delete(tableUser,
        where: "$youtubeid = ?", whereArgs: [id]);
  }

  Future<int> deleteimage(String id) async {
    var dbClient = await db;

    return await dbClient.delete(tableUser2,
        where: "$path = ?", whereArgs: [id]);
  }

  Future<int> deleteall() async {
    var dbClient = await db;

    return await dbClient.delete(tableUser2);
  }
//  Future<int> updateUser(User user) async {
//    var dbClient = await db;
//    return await dbClient.update(tableUser,
//        user.toMap(), where: "$columnId = ?", whereArgs: [user.id]);
//  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }


}
