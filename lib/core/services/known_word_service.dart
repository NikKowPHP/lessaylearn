import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/repositories/known_word_repository.dart';

class KnownWordService {
  final KnownWordRepository _repository;

  KnownWordService(this._repository);

  Future<void> addKnownWord(KnownWordModel knownWord) async {
    await _repository.saveKnownWord(knownWord);
  }

  Future<List<KnownWordModel>> getKnownWords() async {
    return await _repository.getKnownWords();
  }

  Future<void> removeKnownWord(String knownWordId) async {
    await _repository.deleteKnownWord(knownWordId);
  }

  // Add the missing method
  Future<List<KnownWordModel>> getKnownWordsByUserAndLanguage(String userId, String languageId) async {
    return await _repository.getKnownWordsByUserAndLanguage(userId, languageId);
  }
}