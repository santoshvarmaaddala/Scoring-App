class MatchModel {
  final int? id;
  final String type; // 'limited' or 'unlimited'
  final int? oversLimit;
  final DateTime createdAt;

  MatchModel({
    this.id,
    required this.type,
    this.oversLimit,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'overs_limit': oversLimit,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map['id'] as int?,
      type: map['type'] as String,
      oversLimit: map['overs_limit'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
