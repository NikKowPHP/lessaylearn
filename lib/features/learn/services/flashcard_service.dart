// lib/features/learn/services/flashcard_service.dart
import 'package:lessay_learn/core/SRSA/engine/srsa_algoritm.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/services/i_flashcard_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:flutter/cupertino.dart';
class FlashcardService implements IFlashcardService {
  final ILocalStorageService localStorageService;

  FlashcardService(this.localStorageService);

  @override
  Future<List<DeckModel>> getDecks() async {
    return await localStorageService.getDecks();
  }

@override
Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId) async {
  return await localStorageService.getFlashcardsForDeck(deckId);
}

  @override
  Future<void> addDeck(DeckModel deck) async {
    await localStorageService.addDeck(deck);
  }

  @override
  Future<void> addFlashcard(FlashcardModel flashcard) async {
    await localStorageService.addFlashcard(flashcard);
  }

  @override
  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    await localStorageService.updateFlashcard(flashcard);
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await localStorageService.deleteDeck(deckId);
  }

  @override
  Future<void> deleteFlashcard(String flashcardId) async {
    await localStorageService.deleteFlashcard(flashcardId);
  }



  
Future<List<FlashcardModel>> getAllFlashcards() async {
  final flashcards = await localStorageService.getAllFlashcards();
  return flashcards.map((json) => FlashcardModel.fromJson(json as Map<String, dynamic>)).toList();
}

Future<FlashcardModel> reviewFlashcard(FlashcardModel flashcard, int quality) async {
  final updatedFlashcard = SRSAlgorithm.processReview(flashcard, quality);
  debugPrint('Updated flashcard: ${updatedFlashcard.toJson()}');
  await updateFlashcard(updatedFlashcard);
  await updateDeckProgress(updatedFlashcard.deckId);
  return updatedFlashcard;
    
}

  Future<List<FlashcardModel>> getDueFlashcards() async {
    final allFlashcards = await getAllFlashcards();
    final now = DateTime.now();
  return allFlashcards
      .where((card) => card.nextReview.isBefore(now))
      .toList();
  }

  Future<List<FlashcardModel>> getDueFlashcardsForDeck(String deckId) async {
    final allFlashcards = await getFlashcardsForDeck(deckId);
    final now = DateTime.now();
    return allFlashcards
        .where((card) => card.nextReview.isBefore(now))
        .toList();
  }

  Future<void> updateDeckProgress(String deckId) async {
    await localStorageService.updateDeckLastStudied(deckId, DateTime.now());
  }

 Future<Map<String, List<FlashcardModel>>> getFlashcardsByStatus(String deckId) async {

  final deckFlashcards = await getFlashcardsForDeck(deckId);
  final now = DateTime.now();
    return {
      'new': deckFlashcards.where((card) => SRSAlgorithm.isNewCard(card)).toList(),
      'learn': deckFlashcards
          .where((card) => SRSAlgorithm.isLearningCard(card))
          .toList(),
        'review': deckFlashcards
          .where((card) =>
              !SRSAlgorithm.isNewCard(card) &&
            !SRSAlgorithm.isLearningCard(card) &&
            card.nextReview.isBefore(now))
        .toList(),
  };
}
}
