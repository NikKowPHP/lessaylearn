import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class KnownWordService {
  final ILocalStorageService _localStorageService;

  KnownWordService(this._localStorageService);

  Future<void> addKnownWord(KnownWordModel knownWord) async {
    await _localStorageService.saveKnownWord(knownWord);
  }

  Future<List<KnownWordModel>> getKnownWords() async {
    return await _localStorageService.getKnownWords();
  }

  Future<void> removeKnownWord(String knownWordId) async {
    await _localStorageService.deleteKnownWord(knownWordId);
  }

  Future<List<KnownWordModel>> getKnownWordsByUserAndLanguage(String userId, String languageId) async {
    return await _localStorageService.getKnownWordsByUserAndLanguage(userId, languageId);
  }
}