// lib/features/learn/services/i_flashcard_service.dart
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';

abstract class IFlashcardService {
  Future<List<DeckModel>> getDecks();
  Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId);
  Future<void> addDeck(DeckModel deck);
  Future<void> addFlashcard(FlashcardModel flashcard);
  Future<void> updateFlashcard(FlashcardModel flashcard);
  Future<void> deleteDeck(String deckId);
  Future<void> deleteFlashcard(String flashcardId);
}
