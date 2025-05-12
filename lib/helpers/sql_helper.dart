import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE passangers_list(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        street TEXT,
        neighborhood TEXT,
        phone_number TEXT,
        group_id INTEGER NOT NULL,
        going INTEGER NOT NULL
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'passangers_list.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
        await _seedData(database);
      },
    );
  }

  static Future<void> _seedData(sql.Database db) async {
    await db.transaction((txn) async {
      await txn.rawInsert('''
        INSERT INTO passangers_list(name, street, neighborhood, phone_number, group_id, going)
        VALUES
        ("Maria", "Av. Barbacena", "Barro Preto", "(31) 9 7777-7777", 1, 1),
        ("Pedro", "Av. Rio Grande do Norte", "Savassi", "(31) 9 1111-1111", 1, 1),
        ("João Antônio", "R. Santa Rita Durão", "Funcionários", "(31) 9 1111-1111", 1, 1),
        ("Pedro", "Av. Rio Grande do Norte", "Savassi", "(31) 9 1111-1111", 1, 0),
        ("Maria", "Av. Barbacena", "Barro Preto", "(31) 9 1111-1111", 1, 0)
      ''');
    });
  }

  static Future<List<Map<String, dynamic>>> getPassengers(int groupId, bool going) async {
    final db = await SQLHelper.db();
    return db.query(
      'passangers_list',
      where: 'group_id = ? AND going = ?',
      whereArgs: [groupId, going ? 1 : 0],
    );
  }
}
