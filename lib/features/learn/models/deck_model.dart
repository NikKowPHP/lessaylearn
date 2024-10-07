// lib/features/learn/models/deck_model.dart
import 'package:equatable/equatable.dart';

class DeckModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final int cardCount;
  final DateTime lastStudied;
  final String languageLevel;
  final String sourceLanguageId;
  final String targetLanguageId;

  const DeckModel({
    required this.id,
    required this.name,
    required this.description,
    required this.cardCount,
    required this.lastStudied,
    required this.languageLevel,
    required this.sourceLanguageId,
    required this.targetLanguageId,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      cardCount: json['cardCount'] ?? 0,
      lastStudied: json['lastStudied'] != null
          ? DateTime.parse(json['lastStudied'])
          : DateTime.now(),
      languageLevel: json['languageLevel'] ?? '',
      sourceLanguageId: json['sourceLanguage'] ?? '',
      targetLanguageId: json['targetLanguage'] ?? '',
    );
  }



  @override
String toString() {
  return '''DeckModel(
    id: $id,
    name: $name,
    description: $description,
    cardCount: $cardCount,
    lastStudied: $lastStudied,
    languageLevel: $languageLevel,
    sourceLanguage: $sourceLanguageId,
    targetLanguage: $targetLanguageId
  )''';
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cardCount': cardCount,
      'lastStudied': lastStudied.toIso8601String(),
      'languageLevel': languageLevel,
      'sourceLanguage': sourceLanguageId,
      'targetLanguage': targetLanguageId,
    };
  }
   DeckModel copyWith({
    String? id,
    String? name,
    String? description,
    int? cardCount,
    DateTime? lastStudied,
    String? languageLevel,
    String? sourceLanguage,
    String? targetLanguage,
  }) {
    return DeckModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cardCount: cardCount ?? this.cardCount,
      lastStudied: lastStudied ?? this.lastStudied,
      languageLevel: languageLevel ?? this.languageLevel,
      sourceLanguageId: sourceLanguage ?? this.sourceLanguageId,
      targetLanguageId: targetLanguage ?? this.targetLanguageId,
    );
  }

  @override
  List<Object?> get props => [id, name, description, cardCount, lastStudied, languageLevel, sourceLanguageId, targetLanguageId];
}