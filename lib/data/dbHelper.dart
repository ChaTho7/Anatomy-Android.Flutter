import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/models/Tissue.dart';

class DbHelper {
  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "anatomy.db");
    var eTradeDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTradeDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        "Create table tissues(id integer primary key, name text, sort text, region text, gender text)");
  }

  Future<List<Tissue>> getTissues() async {
    Database db = await this.db;
    var result = await db.query("tissues");
    return List.generate(result.length, (index) {
      return Tissue.fromObject(result[index]);
    });
  }

  Future<int> insert(Tissue tissue) async {
    Database db = await this.db;
    var result = await db.insert("tissues", tissue.toMap());
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete("delete from tissues where id=$id");
    return result;
  }

  Future<int> update(Tissue tissue) async {
    Database db = await this.db;
    var result = await db.update("tissues", tissue.toMap(),
        where: "id=?", whereArgs: [tissue.id]);
    return result;
  }
}
