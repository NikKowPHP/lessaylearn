import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/repositories/known_word_repository.dart';
import 'package:lessay_learn/core/services/known_word_service.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';

final knownWordRepositoryProvider = Provider<KnownWordRepository>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return KnownWordRepository(localStorageService);
});

final knownWordServiceProvider = Provider<KnownWordService>((ref) {
  final repository = ref.watch(knownWordRepositoryProvider);
  return KnownWordService(repository);
});

final knownWordsProvider = StateNotifierProvider<KnownWordsNotifier, List<KnownWordModel>>((ref) {
  final repository = ref.watch(knownWordRepositoryProvider);
  return KnownWordsNotifier(repository, ref);
});

final knownWordsByUserAndLanguageProvider = FutureProvider.autoDispose.family<List<KnownWordModel>, (String, String)>((ref, params) async {
  final service = ref.watch(knownWordServiceProvider);
  return await service.getKnownWordsByUserAndLanguage(params.$1, params.$2);
});

class KnownWordsNotifier extends StateNotifier<List<KnownWordModel>> {
  final KnownWordRepository _repository;
  final Ref _ref;

  KnownWordsNotifier(this._repository, this._ref) : super([]) {
    _loadKnownWords();
  }

  Future<void> _loadKnownWords() async {
    final knownWords = await _repository.getKnownWords();
    state = knownWords;
  }

  Future<void> addKnownWord(KnownWordModel word) async {
    await _repository.saveKnownWord(word);
    state = [...state, word];
    _ref.invalidate(knownWordsByUserAndLanguageProvider);
  }

  // Add similar methods for updating and deleting known words
}