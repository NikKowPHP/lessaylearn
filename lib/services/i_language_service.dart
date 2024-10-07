import 'package:lessay_learn/core/models/user_language_model.dart';

abstract class IUserLanguageService {
  Future<void> addLanguage(UserLanguage language);
  Future<List<UserLanguage>> fetchLanguages(String userId);
  Future<UserLanguage?> fetchLanguageById(String languageId);
  Future<void> updateLanguage(UserLanguage language);
  Future<void> removeLanguage(String languageId);
  String calculateLanguageLevel(int score);
  Future<Map<String, String>> getUserLanguageLevels(String userId);
}