import 'package:lessay_learn/core/models/user_language_model.dart';
// import 'package:lessay_learn/services/i_local_storage_service.dart';

import 'package:lessay_learn/services/i_language_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

class LanguageService implements IUserLanguageService {
  final ILocalStorageService _localStorageService;

  LanguageService(this._localStorageService);

  @override
  Future<void> addLanguage(UserLanguage language) async {
    await _localStorageService.saveUserLanguage(language);
  }

  @override
  Future<List<UserLanguage>> fetchLanguages(String userId) async {
    return await _localStorageService.getUserLanguagesByUserId(userId);
  }

  @override
  Future<UserLanguage?> fetchLanguageById(String languageId) async {
    return await _localStorageService.getUserLanguageById(languageId);
  }

  @override
  Future<void> updateLanguage(UserLanguage language) async {
    await _localStorageService.updateUserLanguage(language);
  }

  @override
  Future<void> removeLanguage(String languageId) async {
    await _localStorageService.deleteUserLanguage(languageId);
  }

   @override
  String calculateLanguageLevel(int score) {
    if (score < 0 || score > 1000) {
      throw ArgumentError('Score must be between 0 and 1000');
    }

    if (score < 200) {
      return 'Beginner';
    } else if (score < 400) {
      return 'Elementary';
    } else if (score < 600) {
      return 'Intermediate';
    } else if (score < 800) {
      return 'Upper Intermediate';
    } else if (score < 950) {
      return 'Advanced';
    } else {
      return 'Proficient';
    }
  }
   @override
  Future<Map<String, String>> getUserLanguageLevels(String userId) async {
    final languages = await fetchLanguages(userId);
    return {
      for (var lang in languages)
        lang.id: calculateLanguageLevel(lang.score)
    };
  }
}