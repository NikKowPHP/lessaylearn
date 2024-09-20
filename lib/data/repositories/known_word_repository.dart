import 'package:lessay_learn/core/interfaces/storage_interface.dart';

import '../../core/models/known_word_model.dart';
import '../../services/storage_service.dart';

class KnownWordRepository {
  final StorageService _storageService;

  KnownWordRepository(this._storageService);

  IStorage<KnownWordModel> get _storage => _storageService.getStorage<KnownWordModel>('known_words');

  Future<void> saveKnownWord(KnownWordModel knownWord) => _storage.create(knownWord.id, knownWord);
  Future<List<KnownWordModel>> getKnownWords() => _storage.readAll();
  Future<void> deleteKnownWord(String knownWordId) => _storage.delete(knownWordId);

  Future<List<KnownWordModel>> getKnownWordsByUserAndLanguage(String userId, String languageId) {
    return _storage.query((kw) => kw.userId == userId && kw.language == languageId);
  }
}