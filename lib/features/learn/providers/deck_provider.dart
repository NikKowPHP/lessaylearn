import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart';

final deckServiceProvider = Provider<DeckService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return DeckService(localStorageService);
});


final dueFlashcardCountsProvider = FutureProvider.family<Map<String, int>, String>((ref, deckId) async {
  final deckService = ref.watch(deckServiceProvider);
  return deckService.getDueFlashcardCounts(deckId);
});


final decksProvider = StateNotifierProvider<DeckNotifier, List<DeckModel>>((ref) {
  final deckService = ref.watch(deckServiceProvider);
  return DeckNotifier(deckService);
});

final dueFlashcardCountProvider = FutureProvider.family<int, String>((ref, deckId) async {
  final deckService = ref.watch(deckServiceProvider);
  return deckService.getDueFlashcardCount(deckId);
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
