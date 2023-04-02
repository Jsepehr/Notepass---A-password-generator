// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import "package:path/path.dart" as path;

class DBhelper {
  static String dbName = "pass.db";
  static String tableName = "passwords_new";
  static List<String> columnsNames = ["id", "password", "hint", "used"];

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, dbName),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE IF NOT EXISTS $tableName (${columnsNames[0]} INTEGER, ${columnsNames[1]} TEXT, ${columnsNames[2]} TEXT, ${columnsNames[3]} Boolean)');
    }, version: 5);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBhelper.database();
    debugPrint(
        '${db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace)} insert result');
  }

  static Future<List<Map<String, Object?>>> getData() async {
    final db = await DBhelper.database();
    return db.query(tableName);
  }

  static Future<void> delete(String table) async {
    final db = await DBhelper.database();
    db.delete(table);
  }

  static Future<void> updateRiga(
      {required String tableName,
      required Map<String, Object?> nameValue,
      required int whereArg,
      required String whereColumn}) async {
    final db = await DBhelper.database();
    //metti value a qualcosa dove (prende una map {nome colonna : value da mettere}
    //whereColumn è nome colonna e whereArges va a riempire il ?
    db.update(tableName, nameValue,
        where: '$whereColumn = ?', whereArgs: [whereArg]);
  }

  static Future<List<Map<String, Object?>>> selectOne(
      String table, List<String> columsName, List<int> idNum) async {
    final db = await DBhelper.database();
    return db.query(table,
        columns: columsName, where: '"id" = ?', whereArgs: idNum);
  }

  static Future<List<Map<String, Object?>>> filterByHint(String str) async {
    final db = await DBhelper.database();
    return db.query(tableName,
        columns: columnsNames,
        where: '${columnsNames[2]} LIKE ?',
        whereArgs: ['%$str%']);
  }
}
