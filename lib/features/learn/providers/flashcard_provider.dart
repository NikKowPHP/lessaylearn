import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/language_service_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/services/flashcard_service.dart';

final flashcardServiceProvider = Provider<FlashcardService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return FlashcardService(localStorageService);
});

final dueFlashcardsProvider = FutureProvider<List<FlashcardModel>>((ref) async {
  final service = ref.watch(flashcardServiceProvider);
  return service.getDueFlashcards();
});

final flashcardStatusProvider = FutureProvider.family<Map<String, List<FlashcardModel>>, String>((ref, deckId) async {
  final service = ref.watch(flashcardServiceProvider);
  return service.getFlashcardsByStatus(deckId); // Ensure this method exists and is correctly implemented
});

final decksProvider = FutureProvider<List<DeckModel>>((ref) async {
  final service = ref.watch(flashcardServiceProvider);
  return service.getDecks();
});

final deckByIdProvider = FutureProvider.family<DeckModel, String>((ref, deckId) async {
  final service = ref.watch(flashcardServiceProvider);
  final decks = await service.getDecks();
  return decks.firstWhere((deck) => deck.id == deckId);
});

final flashcardsForDeckProvider = FutureProvider.family<List<FlashcardModel>, String>((ref, deckId) async {
  final service = ref.watch(flashcardServiceProvider);
  return service.getFlashcardsForDeck(deckId);
});

final flashcardNotifierProvider = StateNotifierProvider<FlashcardNotifier, AsyncValue<List<FlashcardModel>>>((ref) {
  final service = ref.watch(flashcardServiceProvider);
  return FlashcardNotifier(service);
});

class FlashcardNotifier extends StateNotifier<AsyncValue<List<FlashcardModel>>> {
  final FlashcardService _service;

  FlashcardNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    try {
      final allFlashcards = await _service.getAllFlashcards();
      state = AsyncValue.data(allFlashcards);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateFlashcard(FlashcardModel updatedFlashcard) async {
    await _service.updateFlashcard(updatedFlashcard);
    await _loadFlashcards();
  }

  Future<void> reviewFlashcard(FlashcardModel flashcard, int quality) async {
    await _service.reviewFlashcard(flashcard, quality);
    await _loadFlashcards();
  }

  Future<List<FlashcardModel>> getDueFlashcards() async {
    return await _service.getDueFlashcards();
  }

  Future<List<FlashcardModel>> getDueFlashcardsForDeck(String deckId) async {
    return await _service.getDueFlashcardsForDeck(deckId);
  }

  Future<void> updateDeckProgress(String deckId) async {
    await _service.updateDeckProgress(deckId);
  }
}