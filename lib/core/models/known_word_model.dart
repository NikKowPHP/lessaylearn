class KnownWordModel {
  final String id;
  final String userId;
  final String word;
  final String language;
  final DateTime createdAt;

  KnownWordModel({
    required this.id,
    required this.userId,
    required this.word,
    required this.language,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory KnownWordModel.fromJson(Map<String, dynamic> json) => KnownWordModel(
    id: json['id'],
    userId: json['userId'],
    word: json['word'],
    language: json['language'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'word': word,
    'language': language,
    'createdAt': createdAt.toIso8601String(),
  };

  KnownWordModel copyWith({
    String? id,
    String? userId,
    String? word,
    String? language,
    DateTime? createdAt,
  }) => KnownWordModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    word: word ?? this.word,
    language: language ?? this.language,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  String toString() => 'KnownWordModel(id: $id, userId: $userId, word: $word, language: $language, createdAt: $createdAt)';
}