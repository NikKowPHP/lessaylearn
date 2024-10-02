import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/SRSA/engine/srsa_algoritm.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/providers/deck_provider.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

class DeckService {
  final ILocalStorageService _storageService;

  DeckService(this._storageService);

  Future<void> notifyProviders(WidgetRef ref, String deckId) async {
    ref.invalidate(flashcardsForDeckProvider(deckId));
    
    ref.invalidate(dueFlashcardCountProvider(deckId));
    ref.invalidate(dueFlashcardCountsProvider(deckId));
  }

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
    return allFlashcards
        .where((flashcard) => flashcard.nextReview.isBefore(now))
        .toList();
  }

  Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId) async {
    final flashcards = await _storageService.getFlashcardsForDeck(deckId);

    return flashcards;
  }

  Future<void> addFlashcard(FlashcardModel flashcard) async {
    await _storageService.addFlashcard(flashcard);
    await _updateDeckCardCount(flashcard.deckId);
  }

  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    await _storageService.updateFlashcard(flashcard);
  }
  Future<bool> isFavoriteAFlashcard(String favoriteId) async {
    final favorite = await _storageService.getFavoriteById(favoriteId);
    return favorite?.isFlashcard ?? false;
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

  Future<Map<String, int>> getDueFlashcardCounts(String deckId) async {
    final allFlashcards = await getFlashcardsForDeck(deckId);
    final now = DateTime.now();

    int newCount = 0;
    int learnCount = 0;
    int reviewCount = 0;

    for (var flashcard in allFlashcards) {
      if (flashcard.nextReview.isBefore(now)) {
        if (flashcard.repetitions == 0) {
          newCount++;
        } else if (flashcard.interval <= 1) {
          learnCount++;
        } else {
          reviewCount++;
        }
      }
    }

    return {
      'new': newCount,
      'learn': learnCount,
      'review': reviewCount,
    };
  }

  Future<int> getDueFlashcardCount(String deckId) async {
    final counts = await getDueFlashcardCounts(deckId);
    return counts['new']! + counts['learn']! + counts['review']!;
  }

  Future<void> addFavoriteAsDeckFlashcard(
      String deckId, String favoriteId) async {
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
    return allFavorites
        .where((favorite) =>
            favorite.sourceLanguage == sourceLanguageId &&
            favorite.targetLanguage == targetLanguageId &&
            !favorite.isFlashcard)
        .toList();
  }

  Future<List<String>> getAvailableSourceLanguages() async {
    final allFavorites = await _storageService.getFavorites();
    return allFavorites.map((f) => f.sourceLanguage).toSet().toList();
  }

  Future<List<String>> getAvailableTargetLanguages(
      String sourceLanguage) async {
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

  Future<DeckModel?> getDeckById(String deckId) async {
    return await _storageService.getDeckById(deckId);
  }

  Future<bool> isFlashcardInDeck(String flashcardId, String deckId) async {
    final flashcards = await _storageService.getFlashcardsForDeck(deckId);
    return flashcards.any((flashcard) => flashcard.id == flashcardId);
  }

 Future<Map<String, List<FlashcardModel>>> getFlashcardStatus(
      List<FlashcardModel> flashcards) async {
    final now = DateTime.now();
    final flashcardStatus = {
      'new': <FlashcardModel>[],
      'learn': <FlashcardModel>[],
      'review': <FlashcardModel>[],
    };

    for (var flashcard in flashcards) {
      if (SRSAlgorithm.isNewCard(flashcard)) {
        flashcardStatus['new']?.add(flashcard);
      } else if (SRSAlgorithm.isLearningCard(flashcard)) {
        flashcardStatus['learn']?.add(flashcard);
      } else if (flashcard.nextReview.isBefore(now)) {
        flashcardStatus['review']?.add(flashcard);
      }
    }

    return flashcardStatus;
  }
}

final deckServiceProvider = Provider<DeckService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return DeckService(localStorageService);
});
