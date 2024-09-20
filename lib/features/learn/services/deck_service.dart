import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:uuid/uuid.dart';

class DeckService {
  final ILocalStorageService _storageService;

  DeckService(this._storageService);

  Future<List<DeckModel>> getDecks() async {
    return await _storageService.getDecks();
  }

  Future<void> addDeck(DeckModel deck) async {
    await _storageService.addDeck(deck);
  }

  Future<void> updateDeck(DeckModel deck) async {
    await _storageService.updateDeck(deck);
  }

  Future<void> deleteDeck(String deckId) async {
    await _storageService.deleteDeck(deckId);
  }
    Future<List<FlashcardModel>> getDueFlashcardsForDeck(String deckId) async {
    final allFlashcards = await getFlashcardsForDeck(deckId);
    final now = DateTime.now();
    return allFlashcards.where((flashcard) => flashcard.nextReview.isBefore(now)).toList();
  }

Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId) async {
  final flashcards = await _storageService.getFlashcardsForDeck(deckId);
  
  return flashcards.map((json) => FlashcardModel.fromJson(json as Map<String, dynamic>)).toList();
}

  Future<void> addFlashcard(FlashcardModel flashcard) async {
    await _storageService.addFlashcard(flashcard);
    await _updateDeckCardCount(flashcard.deckId);
  }

  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    await _storageService.updateFlashcard(flashcard);
  }

  Future<void> deleteFlashcard(String flashcardId, String deckId) async {
    await _storageService.deleteFlashcard(flashcardId);
    await _updateDeckCardCount(deckId);
  }

  Future<void> _updateDeckCardCount(String deckId) async {
    final deck = await _storageService.getDeckById(deckId);
    if (deck != null) {
      final flashcards = await getFlashcardsForDeck(deckId);
      final updatedDeck = deck.copyWith(cardCount: flashcards.length);
      await updateDeck(updatedDeck);
    }
  }

  Future<void> addFavoriteAsDeckFlashcard(String deckId, String favoriteId) async {
    final favorite = await _storageService.getFavoriteById(favoriteId);
    if (favorite != null) {
      final flashcard = FlashcardModel(
        id: Uuid().v4(),
        deckId: deckId,
        front: favorite.sourceText,
        back: favorite.translatedText,
        nextReview: DateTime.now(),
        interval: 0,
        repetitions: 0,
        easeFactor: 2.5,
      );
      await addFlashcard(flashcard);
    }
  }

  Future<List<FavoriteModel>> getFavoritesByLanguages(
    String sourceLanguageId,
    String targetLanguageId,
  ) async {
    final allFavorites = await _storageService.getFavorites();
    return allFavorites.where((favorite) =>
      favorite.sourceLanguage == sourceLanguageId &&
      favorite.targetLanguage == targetLanguageId
    ).toList();
  }

 Future<List<String>> getAvailableSourceLanguages() async {
    final allFavorites = await _storageService.getFavorites();
    return allFavorites.map((f) => f.sourceLanguage).toSet().toList();
  }

  Future<List<String>> getAvailableTargetLanguages(String sourceLanguage) async {
    final allFavorites = await _storageService.getFavorites();
    return allFavorites
        .where((f) => f.sourceLanguage == sourceLanguage)
        .map((f) => f.targetLanguage)
        .toSet()
        .toList();
  }

  Future<void> updateFavoritesAsFlashcards(List<String> favoriteIds) async {
    for (String favoriteId in favoriteIds) {
      final favorite = await _storageService.getFavoriteById(favoriteId);
      if (favorite != null) {
        final updatedFavorite = favorite.copyWith(
          isFlashcard: true,
          addedToFlashcardsDate: DateTime.now(),
        );
        await _storageService.updateFavorite(updatedFavorite);
      }
    }
  }


}

final deckServiceProvider = Provider<DeckService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return DeckService(localStorageService);
});
