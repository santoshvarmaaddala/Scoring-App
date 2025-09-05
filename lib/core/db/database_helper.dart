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
        type TEXT CHECK(type IN ('limited', 'unlimited')) NOT NULL,
        overs_limit INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Batting order & batting stats
    await db.execute('''
      CREATE TABLE batting_order (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        match_id INTEGER NOT NULL,
        player_id INTEGER NOT NULL,
        batting_position INTEGER NOT NULL,
        is_out BOOLEAN DEFAULT 0,
        runs INTEGER DEFAULT 0,
        balls_faced INTEGER DEFAULT 0,
        FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    // Bowling stats
    await db.execute('''
      CREATE TABLE bowling_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        match_id INTEGER NOT NULL,
        player_id INTEGER NOT NULL,
        overs INTEGER DEFAULT 0,
        runs_conceded INTEGER DEFAULT 0,
        wickets INTEGER DEFAULT 0,
        FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    // Deliveries (ball-by-ball log)
    await db.execute('''
      CREATE TABLE deliveries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        match_id INTEGER NOT NULL,
        over_number INTEGER,
        ball_number INTEGER,
        batsman_id INTEGER NOT NULL,
        bowler_id INTEGER NOT NULL,
        runs INTEGER DEFAULT 0,
        is_wicket BOOLEAN DEFAULT 0,
        FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
        FOREIGN KEY (batsman_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (bowler_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');
  }

  // -------------------------------
  // Players CRUD
  // -------------------------------
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

  Future<List<Map<String, Object?>>> rawPlayers() async {
    final db = await instance.database;
    return await db.rawQuery('SELECT * FROM players');
  }

  // -------------------------------
  // Matches CRUD (basic)
  // -------------------------------
  Future<int> insertMatch(Map<String, dynamic> match) async {
    final db = await instance.database;
    return await db.insert('matches', match);
  }

  Future<List<Map<String, dynamic>>> getMatches() async {
    final db = await instance.database;
    return await db.query('matches', orderBy: 'id DESC');
  }

  // -------------------------------
  // Batting Order CRUD
  // -------------------------------
  Future<int> insertBattingOrder(Map<String, dynamic> order) async {
    final db = await instance.database;
    return await db.insert('batting_order', order);
  }

  Future<List<Map<String, dynamic>>> getBattingOrder(int matchId) async {
    final db = await instance.database;
    return await db.query('batting_order',
        where: 'match_id = ?', whereArgs: [matchId], orderBy: 'batting_position ASC');
  }

  // -------------------------------
  // Bowling Stats CRUD
  // -------------------------------
  Future<int> insertBowlingStats(Map<String, dynamic> stats) async {
    final db = await instance.database;
    return await db.insert('bowling_stats', stats);
  }

  Future<List<Map<String, dynamic>>> getBowlingStats(int matchId) async {
    final db = await instance.database;
    return await db.query('bowling_stats', where: 'match_id = ?', whereArgs: [matchId]);
  }

  // -------------------------------
  // Deliveries CRUD
  // -------------------------------
  Future<int> insertDelivery(Map<String, dynamic> delivery) async {
    final db = await instance.database;
    return await db.insert('deliveries', delivery);
  }

  Future<List<Map<String, dynamic>>> getDeliveries(int matchId) async {
    final db = await instance.database;
    return await db.query('deliveries',
        where: 'match_id = ?', whereArgs: [matchId], orderBy: 'id ASC');
  }

  // -------------------------------
  // Close DB
  // -------------------------------
  Future close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
