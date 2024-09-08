import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/services/flashcard_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

abstract class IFlashcardRepository {
  Future<List<DeckModel>> getDecks();
  Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId);
  Future<List<FlashcardModel>> getAllFlashcards();
  Future<void> updateFlashcard(FlashcardModel flashcard);
  Future<void> addDeck(DeckModel deck);
  Future<void> updateDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
  Future<void> addFlashcard(FlashcardModel flashcard);
  Future<void> deleteFlashcard(String flashcardId);
}

class FlashcardRepository implements IFlashcardRepository {
  final ILocalStorageService _localStorageService;
  final FlashcardService _flashcardService;

FlashcardRepository(this._localStorageService, this._flashcardService);


  @override
  Future<List<DeckModel>> getDecks() async {
    return await _flashcardService.getDecks();
  }

  @override
Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId) async {
  final flashcards = await _localStorageService.getFlashcardsForDeck(deckId);
  if (flashcards.isEmpty) {
    return _flashcardService.getMockedFlashcards(deckId);
  }
  return flashcards;
}
  @override
  Future<List<FlashcardModel>> getAllFlashcards() async {
    return await _localStorageService.getAllFlashcards();
  }

  @override
  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    await _localStorageService.updateFlashcard(flashcard);
  }

  @override
  Future<void> addDeck(DeckModel deck) async {
    await _localStorageService.addDeck(deck);
  }

  @override
  Future<void> updateDeck(DeckModel deck) async {
    await _localStorageService.updateDeck(deck);
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await _localStorageService.deleteDeck(deckId);
  }

  @override
  Future<void> addFlashcard(FlashcardModel flashcard) async {
    await _localStorageService.addFlashcard(flashcard);
  }

  @override
  Future<void> deleteFlashcard(String flashcardId) async {
    await _localStorageService.deleteFlashcard(flashcardId);
  }
   Future<void> reviewFlashcard(FlashcardModel flashcard, int quality) async {
    await _flashcardService.reviewFlashcard(flashcard, quality);
  }

  Future<List<FlashcardModel>> getDueFlashcards() async {
    return await _flashcardService.getDueFlashcards();
  }
   Future<List<FlashcardModel>> getDueFlashcardsForDeck(String deckId) async {
    return await _flashcardService.getDueFlashcardsForDeck(deckId);
  }
   Future<void> updateDeckProgress(String deckId) async {
    final deck = await _localStorageService.getDeckById(deckId);
    if (deck != null) {
      final now = DateTime.now();
      await _localStorageService.updateDeckLastStudied(deckId, now);
      // You might want to update other deck progress properties here 
      // based on your application's logic (e.g., percentage complete).
    }
  }
   Future<Map<String, List<FlashcardModel>>> getFlashcardsByStatus() async {
    return await _flashcardService.getFlashcardsByStatus();
  }
  Future<Map<String, List<FlashcardModel>>> getFlashcardsByStatusForDeck(String deckId) async {
    final flashcards = await getFlashcardsForDeck(deckId);
    final now = DateTime.now();

    return {
      'new': flashcards.where((card) => card.repetitions == 0).toList(),
      'learn': flashcards.where((card) => card.repetitions > 0 && card.interval <= 1).toList(),
      'review': flashcards.where((card) => 
        card.repetitions > 0 && 
        card.interval > 1 && 
        card.nextReview.isBefore(now)
      ).toList(),
    };
  }

}