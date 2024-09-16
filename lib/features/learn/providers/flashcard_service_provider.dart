import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/services/flashcard_service.dart';

final flashcardServiceProvider = Provider<FlashcardService>((ref) {
  // Get the ILocalStorageService instance from the provider
  final localStorageService = ref.watch(localStorageServiceProvider);

  // Pass the localStorageService to the FlashcardService constructor
  return FlashcardService(localStorageService); 
});

// ... rest of your code ...