import 'package:lessay_learn/core/models/language_model.dart';

abstract class ILanguageService {
  Future<void> addLanguage(LanguageModel language);
  Future<List<LanguageModel>> fetchLanguages(String userId);
  Future<LanguageModel?> fetchLanguageById(String languageId);
  Future<void> updateLanguage(LanguageModel language);
  Future<void> removeLanguage(String languageId);
}