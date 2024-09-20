import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

class DeckService {
  final ILocalStorageService _storageService;

  DeckService(this._storageService);

  Future<List<LanguageModel>> getLanguages() async {
    return await _storageService.getLanguages();
  }

  Future<List<FavoriteModel>> getFavoritesByLanguages(String sourceLanguageId, String targetLanguageId) async {
    final allFavorites = await _storageService.getFavorites();
    return allFavorites.where((favorite) =>
        favorite.sourceLanguage == sourceLanguageId &&
        favorite.targetLanguage == targetLanguageId
    ).toList();
  }

  Future<void> addDeck(DeckModel deck) async {
    await _storageService.addDeck(deck);
  }
}

final deckServiceProvider = Provider<DeckService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return DeckService(localStorageService);
});
