import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/services/known_word_service.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';

final knownWordServiceProvider = Provider<KnownWordService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return KnownWordService(localStorageService);
});

final knownWordsProvider = StateNotifierProvider<KnownWordsNotifier, List<KnownWordModel>>((ref) {
  final service = ref.watch(knownWordServiceProvider);
  return KnownWordsNotifier(service, ref);
});

final knownWordsByUserAndLanguageProvider = FutureProvider.autoDispose.family<List<KnownWordModel>, (String, String)>((ref, params) async {
  final service = ref.watch(knownWordServiceProvider);
  return await service.getKnownWordsByUserAndLanguage(params.$1, params.$2);
});

class KnownWordsNotifier extends StateNotifier<List<KnownWordModel>> {
  final KnownWordService _service;
  final Ref _ref;

  KnownWordsNotifier(this._service, this._ref) : super([]) {
    _loadKnownWords();
  }

  Future<void> _loadKnownWords() async {
    final knownWords = await _service.getKnownWords();
    state = knownWords;
  }

  Future<void> addKnownWord(KnownWordModel word) async {
    await _service.addKnownWord(word);
    state = [...state, word];
    _ref.invalidate(knownWordsByUserAndLanguageProvider);
  }

  Future<void> removeKnownWord(String knownWordId) async {
    await _service.removeKnownWord(knownWordId);
    state = state.where((word) => word.id != knownWordId).toList();
    _ref.invalidate(knownWordsByUserAndLanguageProvider);
  }

  // Add other methods as needed (e.g., updateKnownWord)
}