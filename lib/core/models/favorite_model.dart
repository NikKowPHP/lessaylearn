class FavoriteModel {
  final String id;
  final String userId;
  final String sourceText;
  final String translatedText;
  final String sourceLanguageId;
  final String targetLanguageId;
  final DateTime createdAt;
  final bool isFlashcard;
  final DateTime? addedToFlashcardsDate;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguageId,
    required this.targetLanguageId,
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
      sourceLanguageId: json['sourceLanguage'],
      targetLanguageId: json['targetLanguage'],
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
      'sourceLanguage': sourceLanguageId,
      'targetLanguage': targetLanguageId,
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
      sourceLanguageId: sourceLanguage ?? this.sourceLanguageId,
      targetLanguageId: targetLanguage ?? this.targetLanguageId,
      createdAt: createdAt ?? this.createdAt,
      isFlashcard: isFlashcard ?? this.isFlashcard,
      addedToFlashcardsDate:
          addedToFlashcardsDate ?? this.addedToFlashcardsDate,
    );
  }

  @override
  String toString() {
    return 'FavoriteModel(id: $id, userId: $userId, sourceText: $sourceText, translatedText: $translatedText, sourceLanguage: $sourceLanguageId, targetLanguage: $targetLanguageId, createdAt: $createdAt , isFlashcard: $isFlashcard, addedToFlashcardsDate: $addedToFlashcardsDate)';
  }
}
