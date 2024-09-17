class LanguageModel {
  final String id;
  final String userId;
  final String name;
  final String shortcut;
  final DateTime timestamp;
  final String level;
  final int score; // from 1 to 1000

  LanguageModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.shortcut,
    required this.timestamp,
    required this.level,
    required this.score,
  });

  @override
  String toString() {
    return '''LanguageModel(
      id: $id,
      userId: $userId,
      name: $name,
      shortcut: $shortcut,
      timestamp: $timestamp,
      level: $level,
      score: $score
    )''';
  }

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      shortcut: json['shortcut'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      level: json['level'] ?? '',
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'shortcut': shortcut,
      'timestamp': timestamp.toIso8601String(),
      'level': level,
      'score': score,
    };
  }

  LanguageModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? shortcut,
    DateTime? timestamp,
    String? level,
    int? score,
  }) {
    return LanguageModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      shortcut: shortcut ?? this.shortcut,
      timestamp: timestamp ?? this.timestamp,
      level: level ?? this.level,
      score: score ?? this.score,
    );
  }
}