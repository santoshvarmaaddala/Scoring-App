// lib/features/players/data/player_model.dart
class Player {
  final int? id;
  final String name;
  final int? age;

  Player({this.id, required this.name, this.age});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
    };
    if (id != null) map['id'] = id;
    if (age != null) map['age'] = age;
    return map;
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as int?,
      name: (map['name'] ?? '') as String,
      age: map['age'] as int?,
    );
  }

  @override
  String toString() => 'Player(id: $id, name: $name, age: $age)';
}
