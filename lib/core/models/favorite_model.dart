class FavoriteModel {
  final String id;
  final String userId;
  final String sourceText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final DateTime createdAt;
  final bool isFlashcard;
  final DateTime? addedToFlashcardsDate;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.isFlashcard = false,
    this.addedToFlashcardsDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      userId: json['userId'],
      sourceText: json['sourceText'],
      translatedText: json['translatedText'],
      sourceLanguage: json['sourceLanguage'],
      targetLanguage: json['targetLanguage'],
      createdAt: DateTime.parse(json['createdAt']),
      isFlashcard: json['isFlashcard'] ?? false,
      addedToFlashcardsDate: json['addedToFlashcardsDate'] != null
          ? DateTime.parse(json['addedToFlashcardsDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sourceText': sourceText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'createdAt': createdAt.toIso8601String(),
      'isFlashcard': isFlashcard,
      'addedToFlashcardsDate': addedToFlashcardsDate?.toIso8601String(),
    };
  }

  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? sourceText,
    String? translatedText,
    String? sourceLanguage,
    String? targetLanguage,
    DateTime? createdAt,
    bool? isFlashcard,
    DateTime? addedToFlashcardsDate,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      createdAt: createdAt ?? this.createdAt,
      isFlashcard: isFlashcard ?? this.isFlashcard,
      addedToFlashcardsDate:
          addedToFlashcardsDate ?? this.addedToFlashcardsDate,
    );
  }

  @override
  String toString() {
    return 'FavoriteModel(id: $id, userId: $userId, sourceText: $sourceText, translatedText: $translatedText, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, createdAt: $createdAt , isFlashcard: $isFlashcard, addedToFlashcardsDate: $addedToFlashcardsDate)';
  }
}
