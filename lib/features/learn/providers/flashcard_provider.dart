import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_service_provider.dart';
import 'package:lessay_learn/features/learn/repositories/flashcard_repository.dart';


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
  final repository = ref.watch(flashcardRepositoryProvider);
  return repository.getFlashcardsForDeck(deckId);
});

final flashcardProvider = StateNotifierProvider<FlashcardNotifier, AsyncValue<List<FlashcardModel>>>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return FlashcardNotifier(repository);
});

class FlashcardNotifier extends StateNotifier<AsyncValue<List<FlashcardModel>>> {
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
      final updatedFlashcards = flashcards.map((f) => f.id == updatedFlashcard.id ? updatedFlashcard : f).toList();
      state = AsyncValue.data(updatedFlashcards);
      await _repository.updateFlashcard(updatedFlashcard);
    });
  }


}