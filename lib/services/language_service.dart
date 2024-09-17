import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/i_language_service.dart';

class LanguageService implements ILanguageService {
  final ILocalStorageService _localStorageService;

  LanguageService(this._localStorageService);

  @override
  Future<void> addLanguage(LanguageModel language) async {
    await _localStorageService.saveLanguage(language);
  }

  @override
  Future<List<LanguageModel>> fetchLanguages(String userId) async {
    return await _localStorageService.getLanguagesByUserId(userId);
  }

  @override
  Future<LanguageModel?> fetchLanguageById(String languageId) async {
    return await _localStorageService.getLanguageById(languageId);
  }

  @override
  Future<void> updateLanguage(LanguageModel language) async {
    await _localStorageService.updateLanguage(language);
  }

  @override
  Future<void> removeLanguage(String languageId) async {
    await _localStorageService.deleteLanguage(languageId);
  }
}