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
final flashcardStatusProvider = FutureProvider<Map<String, List<FlashcardModel>>>((ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return repository.getFlashcardsByStatus();
});

final flashcardNotifierProvider =
    StateNotifierProvider<FlashcardNotifier, AsyncValue<List<FlashcardModel>>>(
        (ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return FlashcardNotifier(repository);
});

final flashcardRepositoryProvider = Provider<FlashcardRepository>((ref) {
  // Get the ILocalStorageService instance from the provider
  final localStorageService = ref.watch(localStorageServiceProvider);
// Get the FlashcardService instance from the provider
  final flashcardService = ref.watch(flashcardServiceProvider);
  // Initialize and return your FlashcardRepository, passing both services
  return FlashcardRepository(localStorageService, flashcardService);
});
final decksProvider = FutureProvider<List<DeckModel>>((ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return repository.getDecks();
});

final flashcardsForDeckProvider = FutureProvider.family<List<FlashcardModel>, String>((ref, deckId) async {
  try {
    final repository = ref.watch(flashcardRepositoryProvider);
  return await repository.getFlashcardsForDeck(deckId);
  } catch (e) {
    print('Error fetching flashcards: $e');
    return [];
  }
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
      final flashcards = await _repository.getAllFlashcards();
      state = AsyncValue.data(flashcards);
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
