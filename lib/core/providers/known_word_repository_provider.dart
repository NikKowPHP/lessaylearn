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

final knownWordsProvider = FutureProvider<List<KnownWordModel>>((ref) async {
  final service = ref.watch(knownWordServiceProvider);
  return await service.getKnownWords();
});