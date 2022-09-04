import 'dart:async';
import 'dart:io';
import 'package:ngu_hanh_ten/models/NguHanhInput.dart';
import 'package:ngu_hanh_ten/models/NguHanhTen.dart';
import 'package:ngu_hanh_ten/scenes/NguHanhPage.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/CungMenh.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static  Database _database;

  static const DB_NAME = "nguhanhten.db";
  static const PWD = "Manuka1603@#";
  static const NAME_TABLE = "ten";
  static const ID = "id";
  static const NAME = "name";
  static const TYPE = "type";

  static const CUNGMENH_TABLE = "cungmenh";
  static const CUNGMENH_ID = "id";
  static const CUNGMENH_NAME = "name";
  static const CUNGMENH_MOD1 = "mod1";
  static const CUNGMENH_MOD2 = "mod2";

  static const FAVORITE_TABLE = "favorites";
  static const FAVORITE_ID = "id";
  static const FAVORITE_SURNAME = "surname";
  static const FAVORITE_FIRSTNAME = "firstname";
  static const FAVORITE_GENDER = "gender";
  static const FAVORITE_KIDDATEBORN = "kidDateBorn";
  static const FAVORITE_DADDATEBORN = "dadDateBorn";
  static const FAVORITE_MOMDATEBORN = "momDateBorn";
  static const FAVORITE_ISFAVORITE = "isFavorite";

  Future<Database> get database async {
    if (_database != null)
      return _database;

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, DB_NAME);

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", DB_NAME));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    }
    // open the database
    _database = await openDatabase(path, password:PWD, onOpen: (db) {

    },);
    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, DB_NAME);

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", DB_NAME));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Database exists!");
    }
  }

  Future<NguHanhTen> getNguHanhTenByName(String name) async {
    final db = await database;
    var result = await db.query(NAME_TABLE, where: "$NAME = ? COLLATE NOCASE", whereArgs: [name]);
    return result.isNotEmpty ? NguHanhTen.fromJson(result.first) : null;
  }

  Future<CungMenh> getCungMenhByMod(int mod) async {
    final db = await database;
    var result = await db.query(CUNGMENH_TABLE, where: "$CUNGMENH_MOD1 = ? OR $CUNGMENH_MOD2 = ?", whereArgs: [mod, mod]);
    return result.isNotEmpty ? CungMenh.fromJson(result.first) : null;
  }

  Future<List<NguHanhTen>> get50Names(String name, int offset) async {
    final db = await database;
    List<Map> results = await db.query(NAME_TABLE, columns: [ID, NAME, TYPE],
        where: "$NAME LIKE ?",
        whereArgs: ["%$name%"],
        limit: 50,
        offset: offset,
        orderBy: "$ID ASC");
    List<NguHanhTen> nhts = [];
    results.forEach((result) {
      NguHanhTen nht = NguHanhTen.fromJson(result);
      nhts.add(nht);
    });
    return nhts;
  }

  Future<List<NguHanhTen>> getAllName(String name) async {
    final db = await database;
    List<Map> results = await db.query(NAME_TABLE, columns: [ID, NAME, TYPE], orderBy: "$ID ASC");
    List<NguHanhTen> nhts = [];
    results.forEach((result) {
      NguHanhTen nht = NguHanhTen.fromJson(result);
      nhts.add(nht);
    });
    return nhts;
  }

  Future<List<NguHanhTen>> get10SuggestedNamesByType(String type) async {
    final db = await database;
    List<Map> results = await db.query(NAME_TABLE, where: "$TYPE = ?", whereArgs: [type], orderBy: "RANDOM()", limit: 10);
    List<NguHanhTen> nhts = [];
    results.forEach((result) {
      NguHanhTen nht = NguHanhTen.fromJson(result);
      nhts.add(nht);
    });
    return nhts;
  }

  Future<List<NguHanhTen>> get50NamesByType(String name, String type, int offset) async {
    final db = await database;
    List<Map> results = await db.query(NAME_TABLE, columns: [ID, NAME, TYPE],
        where: "$NAME LIKE ? and $TYPE = ?", whereArgs: ['%$name%', type],
        limit: 50, offset: offset,
        orderBy: "$ID ASC");
    List<NguHanhTen> nhts = [];
    results.forEach((result) {
      NguHanhTen nht = NguHanhTen.fromJson(result);
      nhts.add(nht);
    });
    return nhts;
  }

  Future<List<NguHanhTen>> getNameByType(String name, String type) async {
    final db = await database;
    List<Map> results = await db.query(NAME_TABLE, columns: [ID, NAME, TYPE],
        where: "$NAME LIKE ? and $TYPE = ?", whereArgs: ['%$name%', type], orderBy: "$NAME DESC");
    List<NguHanhTen> nhts = [];
    results.forEach((result) {
      NguHanhTen nht = NguHanhTen.fromJson(result);
      nhts.add(nht);
    });
    return nhts;
  }

  Future<int> setFavoriteName(NguHanhInput nhi) async {
    final db = await database;
    await DBProvider.db.getFavoriteNameByFields(nhi).then((value) {
      if (value != null) {
        nhi = value;
      }
    });
    if (nhi.isFavorite == 1){
      return 0;
    }
    nhi.isFavorite = 1;
    int insertedCount = await db.insert(FAVORITE_TABLE, nhi.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return insertedCount;
  }

  Future<int> unsetFavoriteName(NguHanhInput nhi) async {
    final db = await database;
    nhi.isFavorite = 0;
    int updateCount = await db.update(FAVORITE_TABLE, nhi.toJson(), where: "$FAVORITE_ID = ?", whereArgs: [nhi.id]);
    return updateCount;
  }

  Future<List<NguHanhInput>> getAllFavoriteName() async {
    final db = await database;
    List<Map> results = await db.query(FAVORITE_TABLE, orderBy: "$FAVORITE_ID ASC");
    List<NguHanhInput> nhis = [];
    results.forEach((result) {
      NguHanhInput nhi = NguHanhInput.fromJson(result);
      nhis.add(nhi);
    });
    return nhis;
  }

  Future<NguHanhInput> getFavoriteNameByFields(NguHanhInput nhi) async {
    final db = await database;
    final dateFormatter = DateFormat("dd/MM/yyyy");
    List<Map> results = await db.query(FAVORITE_TABLE,
        where: "$FAVORITE_SURNAME = ? and $FAVORITE_FIRSTNAME = ?"
            " and $FAVORITE_GENDER = ?"
            " and $FAVORITE_KIDDATEBORN = ?"
            " and $FAVORITE_DADDATEBORN = ?"
            " and $FAVORITE_MOMDATEBORN = ?",
        whereArgs: [nhi.surname, nhi.firstname, nhi.gender == Gender.male ? 0 : 1,
          dateFormatter.format(nhi.kidDateBorn).toString(),
          dateFormatter.format(nhi.dadDateBorn).toString(),
          dateFormatter.format(nhi.momDateBorn).toString(),
        ]
    );
    return results.isNotEmpty ? NguHanhInput.fromJson(results.first) : null;
  }
}

