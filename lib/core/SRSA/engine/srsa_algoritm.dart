import 'package:lessay_learn/features/learn/models/flashcard_model.dart';

class SRSAlgorithm {
  static FlashcardModel processReview(FlashcardModel card, int quality) {
    quality = quality.clamp(0, 5);

    double newEaseFactor = card.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    newEaseFactor = newEaseFactor.clamp(1.3, double.infinity);

    int newInterval;
    int newRepetitions = card.repetitions;

    if (quality < 3) {
      // Failed recall
      newInterval = 1;
      if (newRepetitions > 0) {
        newRepetitions--;
      }
    } else {
      // Successful recall
      if (newRepetitions == 0) {
        // First successful review of a new card
        newInterval = 1;
        newRepetitions = 1;
      } else if (newRepetitions == 1) {
        // Second successful review
        newInterval = 6;
        newRepetitions = 2;
      } else {
        newInterval = (card.interval * newEaseFactor).round();
        newRepetitions++;
      }
    }

    newInterval = newInterval.clamp(1, 365 * 10); // Cap at 10 years

    DateTime newNextReviewDate = DateTime.now().add(Duration(days: newInterval));

    return card.copyWith(
      interval: newInterval,
      easeFactor: newEaseFactor,
      repetitions: newRepetitions,
      nextReview: newNextReviewDate,
    );
  }

  static bool isLearningCard(FlashcardModel card) {
    return card.repetitions > 0 && card.interval <= 21;
  }

  static bool isNewCard(FlashcardModel card) {
    return card.repetitions == 0;
  }
}