import 'package:lessay_learn/features/learn/models/flashcard_model.dart';

class SRSAlgorithm {
  static FlashcardModel processReview(FlashcardModel card, int quality) {
    quality = quality.clamp(0, 3);
    int newRepetitions = card.repetitions;
    double newEaseFactor = card.easeFactor;
    int newInterval;
    DateTime newNextReviewDate;

    if (quality >= 1) { // Correct response
      switch (newRepetitions) {
        case 0: // First review
          newInterval = 1;
          break;
        case 1: // Second review
          newInterval = 6;
          break;
        default: // Third review and onwards
          newInterval = (card.interval * newEaseFactor).round();
      }

      // Update ease factor
      newEaseFactor = _updateEaseFactor(newEaseFactor, quality);
      newRepetitions++;
      newNextReviewDate = DateTime.now().add(Duration(days: newInterval));
    } else { // Incorrect response (Again)
      newRepetitions = 0;
      newInterval = 0; // Set to 0 for immediate review
      newNextReviewDate = DateTime.now(); // Set to now for immediate review
    }

    newInterval = newInterval.clamp(0, 365 * 10); // Cap at 10 years, allow 0 for immediate review

    return card.copyWith(
      interval: newInterval,
      easeFactor: newEaseFactor,
      repetitions: newRepetitions,
      nextReview: newNextReviewDate,
    );
  }

  static double _updateEaseFactor(double oldEase, int quality) {
    double newEase = oldEase + (0.1 - (3 - quality) * (0.08 + (3 - quality) * 0.02));
    return newEase.clamp(1.3, 2.5);
  }

  static bool isLearningCard(FlashcardModel card) {
    return card.repetitions < 3;
  }

  static bool isNewCard(FlashcardModel card) {
    return card.repetitions == 0;
  }

  static bool isGraduatedCard(FlashcardModel card) {
    return card.repetitions >= 3;
  }
}