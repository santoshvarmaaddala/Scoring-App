class BattingOrder {
  final int? id;
  final int matchId;
  final int playerId;
  final int battingPosition;
  final bool isOut;
  final int runs;
  final int ballsFaced;

  BattingOrder({
    this.id,
    required this.matchId,
    required this.playerId,
    required this.battingPosition,
    this.isOut = false,
    this.runs = 0,
    this.ballsFaced = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'match_id': matchId,
      'player_id': playerId,
      'batting_position': battingPosition,
      'is_out': isOut ? 1 : 0,
      'runs': runs,
      'balls_faced': ballsFaced,
    };
  }

  factory BattingOrder.fromMap(Map<String, dynamic> map) {
    return BattingOrder(
      id: map['id'] as int?,
      matchId: map['match_id'] as int,
      playerId: map['player_id'] as int,
      battingPosition: map['batting_position'] as int,
      isOut: (map['is_out'] as int) == 1,
      runs: map['runs'] as int,
      ballsFaced: map['balls_faced'] as int,
    );
  }
}
