import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_service_provider.dart';
import 'package:lessay_learn/features/learn/repositories/flashcard_repository.dart';

final dueFlashcardsProvider = FutureProvider<List<FlashcardModel>>((ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return repository.getDueFlashcards();
});
final flashcardStatusProvider = FutureProvider.family<Map<String, List<FlashcardModel>>, String>((ref, deckId) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return repository.getFlashcardsByStatusForDeck(deckId);
});

final flashcardNotifierProvider =
    StateNotifierProvider<FlashcardNotifier, AsyncValue<List<FlashcardModel>>>(
        (ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return FlashcardNotifier(repository);
});

final flashcardRepositoryProvider = Provider<FlashcardRepository>((ref) {

  final localStorageService = ref.watch(localStorageServiceProvider);

  final flashcardService = ref.watch(flashcardServiceProvider);

  return FlashcardRepository(localStorageService, flashcardService);
});
final decksProvider = FutureProvider<List<DeckModel>>((ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return repository.getDecks();
});

// Add this provider
final deckByIdProvider = FutureProvider.family<DeckModel, String>((ref, deckId) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return repository.getDeckById(deckId);
});

// Update this provider if needed
final flashcardsForDeckProvider = FutureProvider.family<List<FlashcardModel>, String>((ref, deckId) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return repository.getFlashcardsForDeck(deckId);
});

final flashcardProvider =
    StateNotifierProvider<FlashcardNotifier, AsyncValue<List<FlashcardModel>>>(
        (ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return FlashcardNotifier(repository);
});

class FlashcardNotifier
    extends StateNotifier<AsyncValue<List<FlashcardModel>>> {
  final FlashcardRepository _repository;

  FlashcardNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    try {
      // Load all flashcards
      final allFlashcards = await _repository.getAllFlashcards();

      // Load due flashcards
      final dueFlashcards = await _repository.getDueFlashcards();

      // Combine all flashcards and due flashcards
      final combinedFlashcards = [...allFlashcards, ...dueFlashcards];

      // Update the state with the combined list
      state = AsyncValue.data(combinedFlashcards);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateFlashcard(FlashcardModel updatedFlashcard) async {
    state.whenData((flashcards) async {
      final updatedFlashcards = flashcards
          .map((f) => f.id == updatedFlashcard.id ? updatedFlashcard : f)
          .toList();
      state = AsyncValue.data(updatedFlashcards);
      await _repository.updateFlashcard(updatedFlashcard);
    });
  }

  Future<void> reviewFlashcard(FlashcardModel flashcard, int quality) async {
    await _repository.reviewFlashcard(flashcard, quality);
    await _loadFlashcards();
  }

  Future<List<FlashcardModel>> getDueFlashcards() async {
    return await _repository.getDueFlashcards();
  }

  Future<void> startStudySession(String deckId) async {
    final dueFlashcards = await _repository.getDueFlashcardsForDeck(deckId);
    state = AsyncValue.data(dueFlashcards);
  }

  Future<List<FlashcardModel>> getDueFlashcardsForDeck(String deckId) async {
    return await _repository.getDueFlashcardsForDeck(deckId);
  }

  Future<void> updateDeckProgress(String deckId) async {
    await _repository.updateDeckProgress(deckId);
  }


  
}
