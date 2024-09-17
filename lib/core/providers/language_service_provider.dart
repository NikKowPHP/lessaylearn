import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/services/i_language_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/language_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

final localStorageServiceProvider = Provider<ILocalStorageService>((ref) {
  return LocalStorageService();
});

final languageServiceProvider = Provider<ILanguageService>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return LanguageService(localStorage);
});

final languagesProvider = FutureProvider.family<List<LanguageModel>, String>((ref, userId) {
  final languageService = ref.watch(languageServiceProvider);
  return languageService.fetchLanguages(userId);
});

final languageByIdProvider = FutureProvider.family<LanguageModel?, String>((ref, languageId) {
  final languageService = ref.watch(languageServiceProvider);
  return languageService.fetchLanguageById(languageId);
});