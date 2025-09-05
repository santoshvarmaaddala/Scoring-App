// lib/core/db/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import './models/match_model.dart';
import './models/player_model.dart';
import './models/batting_order_model.dart';
import './models/bowling_stats_model.dart';
import './models/delivery_model.dart';

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
    // Players
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        age INTEGER
      )
    ''');

    // Matches
    await db.execute('''
      CREATE TABLE matches (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        overs_limit INTEGER,
        created_at TEXT NOT NULL
      )
    ''');

    // Batting Order
    await db.execute('''
      CREATE TABLE batting_order (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        match_id INTEGER NOT NULL,
        player_id INTEGER NOT NULL,
        batting_position INTEGER NOT NULL,
        is_out INTEGER DEFAULT 0,
        runs INTEGER DEFAULT 0,
        balls_faced INTEGER DEFAULT 0,
        FOREIGN KEY (match_id) REFERENCES matches (id) ON DELETE CASCADE,
        FOREIGN KEY (player_id) REFERENCES players (id) ON DELETE CASCADE
      )
    ''');

    // Bowling Stats
    await db.execute('''
      CREATE TABLE bowling_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        match_id INTEGER NOT NULL,
        player_id INTEGER NOT NULL,
        overs INTEGER DEFAULT 0,
        runs_conceded INTEGER DEFAULT 0,
        wickets INTEGER DEFAULT 0,
        FOREIGN KEY (match_id) REFERENCES matches (id) ON DELETE CASCADE,
        FOREIGN KEY (player_id) REFERENCES players (id) ON DELETE CASCADE
      )
    ''');

    // Deliveries
    await db.execute('''
      CREATE TABLE deliveries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        match_id INTEGER NOT NULL,
        over_number INTEGER NOT NULL,
        ball_number INTEGER NOT NULL,
        batsman_id INTEGER NOT NULL,
        bowler_id INTEGER NOT NULL,
        runs INTEGER DEFAULT 0,
        is_wicket INTEGER DEFAULT 0,
        FOREIGN KEY (match_id) REFERENCES matches (id) ON DELETE CASCADE,
        FOREIGN KEY (batsman_id) REFERENCES players (id) ON DELETE CASCADE,
        FOREIGN KEY (bowler_id) REFERENCES players (id) ON DELETE CASCADE
      )
    ''');
  }

  // ===========================
  // PLAYER CRUD
  // ===========================
  Future<int> insertPlayer(Player player) async {
    final db = await instance.database;
    return await db.insert(
      'players',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<List<Player>> getPlayers() async {
    final db = await instance.database;
    final rows = await db.query('players', orderBy: 'id ASC');
    return rows.map((r) => Player.fromMap(r)).toList();
  }

  Future<int> updatePlayer(Player player) async {
    final db = await instance.database;
    return await db.update(
      'players',
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<int> deletePlayer(int id) async {
    final db = await instance.database;
    return await db.delete('players', where: 'id = ?', whereArgs: [id]);
  }

  // ===========================
  // MATCH CRUD
  // ===========================
  Future<int> insertMatch(MatchModel match) async {
    final db = await instance.database;
    return await db.insert('matches', match.toMap());
  }

  Future<List<MatchModel>> getMatches() async {
    final db = await instance.database;
    final rows = await db.query('matches', orderBy: 'id DESC');
    return rows.map((r) => MatchModel.fromMap(r)).toList();
  }

  // ===========================
  // BATTING ORDER CRUD
  // ===========================
  Future<int> insertBattingOrder(BattingOrder order) async {
    final db = await instance.database;
    return await db.insert('batting_order', order.toMap());
  }

  Future<List<BattingOrder>> getBattingOrder(int matchId) async {
    final db = await instance.database;
    final rows = await db.query(
      'batting_order',
      where: 'match_id = ?',
      whereArgs: [matchId],
      orderBy: 'batting_position ASC',
    );
    return rows.map((r) => BattingOrder.fromMap(r)).toList();
  }

  Future<int> updateBattingOrder(BattingOrder order) async {
    final db = await instance.database;
    return await db.update(
      'batting_order',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  // ===========================
  // BOWLING STATS CRUD
  // ===========================
  Future<int> insertBowlingStats(BowlingStats stats) async {
    final db = await instance.database;
    return await db.insert('bowling_stats', stats.toMap());
  }

  Future<List<BowlingStats>> getBowlingStats(int matchId) async {
    final db = await instance.database;
    final rows = await db.query(
      'bowling_stats',
      where: 'match_id = ?',
      whereArgs: [matchId],
    );
    return rows.map((r) => BowlingStats.fromMap(r)).toList();
  }

  Future<int> updateBowlingStats(BowlingStats stats) async {
    final db = await instance.database;
    return await db.update(
      'bowling_stats',
      stats.toMap(),
      where: 'id = ?',
      whereArgs: [stats.id],
    );
  }

  // ===========================
  // DELIVERIES CRUD
  // ===========================
  Future<int> insertDelivery(Delivery delivery) async {
    final db = await instance.database;
    return await db.insert('deliveries', delivery.toMap());
  }

  Future<List<Delivery>> getDeliveries(int matchId) async {
    final db = await instance.database;
    final rows = await db.query(
      'deliveries',
      where: 'match_id = ?',
      whereArgs: [matchId],
      orderBy: 'over_number ASC, ball_number ASC',
    );
    return rows.map((r) => Delivery.fromMap(r)).toList();
  }

  // ===========================
  // UTILS
  // ===========================
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
