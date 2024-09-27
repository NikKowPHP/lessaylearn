import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/favorite_provider.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart';
import 'package:lessay_learn/features/learn/services/import_flashcards_service.dart';

final deckServiceProvider = Provider<DeckService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return DeckService(localStorageService);
});


final availableFavoritesCountProvider = FutureProvider.family<int, String>((ref, deckId) async {
  final favoriteService = ref.watch(favoriteServiceProvider);
  final deckService = ref.watch(deckServiceProvider);

  
  final deck = await deckService.getDeckById(deckId);
  if (deck == null) return 0; // Handle case where deck is not found
  
  final allFavoritesByLanguage = await favoriteService.getAvailableFavoritesByLanguage(deck.sourceLanguage, deck.targetLanguage);

  int availableCount = 0;
  for (final favorite in allFavoritesByLanguage) {
    final isFlashcard = await deckService.isFavoriteAFlashcard(favorite.id);
    if (!isFlashcard) {
      final isInDeck = await deckService.isFlashcardInDeck(favorite.id, deckId);
      if (!isInDeck) {
        availableCount++;
      }
    }
  }

  return availableCount;
});

final dueFlashcardCountsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, deckId) async {
  final deckService = ref.watch(deckServiceProvider);
  return deckService.getDueFlashcardCounts(deckId);
});
final deckByIdProvider =
    FutureProvider.family<DeckModel?, String>((ref, deckId) async {
  final deckService = ref.watch(deckServiceProvider);
  return deckService.getDeckById(deckId);
});

final deckWithFlashcardsStatusProvider = FutureProvider.family<
    Map<String, List<FlashcardModel>>,
    List<FlashcardModel>>((ref, flashcards) async {
  final deckService = ref.watch(deckServiceProvider);
  return deckService.getFlashcardStatus(flashcards);
});

final decksProvider =
    StateNotifierProvider<DeckNotifier, List<DeckModel>>((ref) {
  final deckService = ref.watch(deckServiceProvider);
  return DeckNotifier(deckService);
});

final dueFlashcardCountProvider =
    FutureProvider.family<int, String>((ref, deckId) async {
  final deckService = ref.watch(deckServiceProvider);
  return deckService.getDueFlashcardCount(deckId);
});

final importFlashcardsServiceProvider =
    Provider<ImportFlashcardsService>((ref) {
  final deckService = ref.watch(deckServiceProvider);
  final favoriteService = ref.watch(favoriteServiceProvider);
  final userService = ref.watch(userServiceProvider);
  return ImportFlashcardsService(deckService, favoriteService, userService);
});

class DeckNotifier extends StateNotifier<List<DeckModel>> {
  final DeckService _deckService;

  DeckNotifier(this._deckService) : super([]) {
    loadDecks();
  }

  Future<Map<String, int>> getDueFlashcardCounts(String deckId) {
    return _deckService.getDueFlashcardCounts(deckId);
  }

  Future<void> loadDecks() async {
    final decks = await _deckService.getDecks();
    state = decks;
  }

  Future<void> refreshDeckProviders(WidgetRef ref, String deckId) async {
    ref.invalidate(flashcardsForDeckProvider(deckId));
    ref.invalidate(flashcardStatusProvider(deckId));
    ref.invalidate(dueFlashcardCountsProvider(deckId));
    ref.invalidate(dueFlashcardCountProvider(deckId));
     ref.invalidate(availableFavoritesCountProvider(deckId));
    
    // Add any other providers that need refreshing here
  }

  Future<void> addDeck(DeckModel deck) async {
    await _deckService.addDeck(deck);
    await loadDecks();
  }

  Future<void> updateDeck(DeckModel deck) async {
    await _deckService.updateDeck(deck);
    await loadDecks();
  }

  Future<void> deleteDeck(String deckId) async {
    await _deckService.deleteDeck(deckId);
    await loadDecks();
  }
}
