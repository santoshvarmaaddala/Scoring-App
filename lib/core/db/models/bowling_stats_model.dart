class BowlingStats {
  final int? id;
  final int matchId;
  final int playerId;
  final int overs;
  final int runsConceded;
  final int wickets;

  BowlingStats({
    this.id,
    required this.matchId,
    required this.playerId,
    this.overs = 0,
    this.runsConceded = 0,
    this.wickets = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'match_id': matchId,
      'player_id': playerId,
      'overs': overs,
      'runs_conceded': runsConceded,
      'wickets': wickets,
    };
  }

  factory BowlingStats.fromMap(Map<String, dynamic> map) {
    return BowlingStats(
      id: map['id'] as int?,
      matchId: map['match_id'] as int,
      playerId: map['player_id'] as int,
      overs: map['overs'] as int,
      runsConceded: map['runs_conceded'] as int,
      wickets: map['wickets'] as int,
    );
  }
}
