// lib/core/db/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../features/players/data/player_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scoring_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER
      )
    ''');
    }

  Future<int> insertPlayer(Player player) async {
    final db = await instance.database;
    final id = await db.insert(
      'players',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Player>> getPlayers() async {
    final db = await instance.database;
    final rows = await db.query('players', orderBy: 'id ASC');
    return rows.map((r) => Player.fromMap(r)).toList();
  }

  Future<int> deletePlayer(int id) async {
    final db = await instance.database;
    final cnt = await db.delete('players', where: 'id = ?', whereArgs: [id]);
    return cnt;
  }

  // helpful debug helper to dump raw query result
  Future<List<Map<String, Object?>>> rawPlayers() async {
    final db = await instance.database;
    return await db.rawQuery('SELECT * FROM players');
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
