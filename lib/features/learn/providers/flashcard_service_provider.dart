import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/services/flashcard_service.dart';

final flashcardServiceProvider = Provider<FlashcardService>((ref) {
  // Get the ILocalStorageService instance from the provider
  final localStorageService = ref.watch(localStorageServiceProvider);

  // Pass the localStorageService to the FlashcardService constructor
  return FlashcardService(localStorageService);
});

final flashcardsProvider = StateNotifierProvider<FlashcardNotifier, List<FlashcardModel>>((ref) {
  final flashcardService = ref.watch(flashcardServiceProvider);
  return FlashcardNotifier(flashcardService);
});

class FlashcardNotifier extends StateNotifier<List<FlashcardModel>> {
  final FlashcardService _flashcardService;

  FlashcardNotifier(this._flashcardService) : super([]);

  Future<void> loadFlashcards() async {
    final flashcards = await _flashcardService.getAllFlashcards();
    state = flashcards;
  }
}

