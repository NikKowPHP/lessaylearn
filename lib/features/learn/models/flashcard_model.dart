// lib/features/learn/models/flashcard_model.dart
import 'package:equatable/equatable.dart';

class FlashcardModel extends Equatable {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final DateTime nextReview; 
  final int interval;
  final double easeFactor;
  final int repetitions;

  const FlashcardModel({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    required this.nextReview,
    required this.interval,
    this.repetitions = 0,
    this.easeFactor = 2.5,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'] ?? '',
      deckId: json['deckId'] ?? '',
      front: json['front'] ?? '',
      back: json['back'] ?? '',
      nextReview: json['nextReview'] != null
          ? DateTime.parse(json['nextReview'])
          : DateTime.now(),
      interval: json['interval'] ?? 0,
      easeFactor: json['easeFactor'] ?? 2.5,
      repetitions: json['repetitions'] ?? 0,
    );
  }
  @override
String toString() {
  return '''FlashcardModel(
    id: $id,
    deckId: $deckId,
    front: $front,
    back: $back,
    nextReview: $nextReview,
    interval: $interval,
    easeFactor: $easeFactor,
    repetitions: $repetitions
  )''';
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deckId': deckId,
      'front': front,
      'back': back,
      'nextReview': nextReview.toIso8601String(),
      'interval': interval,
      'easeFactor': easeFactor,
      'repetitions': repetitions,
    };
  }

  FlashcardModel copyWith({
    String? id,
    String? deckId,
    String? front,
    String? back,
    DateTime? nextReview,
    int? interval,
    double? easeFactor,
    int? repetitions,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      nextReview: nextReview ?? this.nextReview,
      interval: interval ?? this.interval,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        deckId,
        front,
        back,
        nextReview,
        interval,
        easeFactor,
        repetitions,
      ];
}