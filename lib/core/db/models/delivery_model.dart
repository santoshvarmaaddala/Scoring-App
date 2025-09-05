class Delivery {
  final int? id;
  final int matchId;
  final int overNumber;
  final int ballNumber;
  final int batsmanId;
  final int bowlerId;
  final int runs;
  final bool isWicket;

  Delivery({
    this.id,
    required this.matchId,
    required this.overNumber,
    required this.ballNumber,
    required this.batsmanId,
    required this.bowlerId,
    this.runs = 0,
    this.isWicket = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'match_id': matchId,
      'over_number': overNumber,
      'ball_number': ballNumber,
      'batsman_id': batsmanId,
      'bowler_id': bowlerId,
      'runs': runs,
      'is_wicket': isWicket ? 1 : 0,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'] as int?,
      matchId: map['match_id'] as int,
      overNumber: map['over_number'] as int,
      ballNumber: map['ball_number'] as int,
      batsmanId: map['batsman_id'] as int,
      bowlerId: map['bowler_id'] as int,
      runs: map['runs'] as int,
      isWicket: (map['is_wicket'] as int) == 1,
    );
  }
}
