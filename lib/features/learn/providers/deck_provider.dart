import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart';

final deckServiceProvider = Provider<DeckService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return DeckService(localStorageService);
});

final decksProvider = StateNotifierProvider<DeckNotifier, List<DeckModel>>((ref) {
  final deckService = ref.watch(deckServiceProvider);
  return DeckNotifier(deckService);
});

class DeckNotifier extends StateNotifier<List<DeckModel>> {
  final DeckService _deckService;

  DeckNotifier(this._deckService) : super([]) {
    loadDecks();
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
