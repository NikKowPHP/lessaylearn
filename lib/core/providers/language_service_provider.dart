import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/features/voicer/services/recording_service.dart';
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
final allLanguagesProvider = FutureProvider<List<LanguageModel>>((ref) async {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return await localStorageService.getLanguages();
});

final calculateLanguageLevelProvider = Provider.family<String, int>((ref, score) {
  final languageService = ref.watch(languageServiceProvider);
  return languageService.calculateLanguageLevel(score);
});

final userLanguageLevelsProvider = FutureProvider.family<Map<String, String>, String>((ref, userId) {
  final languageService = ref.watch(languageServiceProvider);
  return languageService.getUserLanguageLevels(userId);
});

// Add this provider
final recordingServiceProvider = Provider<RecordingService>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return RecordingService(localStorage);
});