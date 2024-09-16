import 'package:lessay_learn/features/learn/models/flashcard_model.dart';

class SRSAlgorithm {
  static FlashcardModel processReview(FlashcardModel card, int quality) {
    double newEaseFactor = card.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    newEaseFactor = newEaseFactor < 1.3 ? 1.3 : newEaseFactor;

    int newInterval;
    if (quality < 3) {
      newInterval = 1;
    } else if (card.repetitions == 0) {
      newInterval = 1;
    } else if (card.repetitions == 1) {
      newInterval = 6;
    } else {
      newInterval = (card.interval * card.easeFactor).round();
    }

    DateTime newNextReviewDate = DateTime.now().add(Duration(days: newInterval));

    return card.copyWith(
      interval: newInterval,
      easeFactor: newEaseFactor,
      repetitions: quality < 3 ? 0 : card.repetitions + 1,
      nextReview: newNextReviewDate,
    );
  }
}
