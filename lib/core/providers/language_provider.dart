import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/features/voicer/services/recording_service.dart';
import 'package:lessay_learn/services/i_language_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/language_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

final localStorageServiceProvider = Provider<ILocalStorageService>((ref) {
  return LocalStorageService();
});

final userLanguageServiceProvider = Provider<IUserLanguageService>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return LanguageService(localStorage);
});

final userLanguagesProvider = FutureProvider.family<List<UserLanguage>, String>((ref, userId) {
  final languageService = ref.watch(userLanguageServiceProvider);
  return languageService.fetchLanguages(userId);
});

final userLanguageByIdProvider = FutureProvider.family<UserLanguage?, String>((ref, languageId) {
  final languageService = ref.watch(userLanguageServiceProvider);
  return languageService.fetchLanguageById(languageId);
});
final allUserLanguagesProvider = FutureProvider<List<UserLanguage>>((ref) async {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return await localStorageService.getUserLanguages();
});

final calculateLanguageLevelProvider = Provider.family<String, int>((ref, score) {
  final languageService = ref.watch(userLanguageServiceProvider);
  return languageService.calculateLanguageLevel(score);
});

final userLanguageLevelsProvider = FutureProvider.family<Map<String, String>, String>((ref, userId) {
  final languageService = ref.watch(userLanguageServiceProvider);
  return languageService.getUserLanguageLevels(userId);
});

// Add this provider
final recordingServiceProvider = Provider<RecordingService>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return RecordingService(localStorage);
});
final userLanguageModelsByIdsProvider = FutureProvider.family<List<UserLanguage>, List<String>>((ref, languageIds) async {
  final languageService = ref.watch(userLanguageServiceProvider);
  final futures = languageIds.map((id) => languageService.fetchLanguageById(id));
  final languages = await Future.wait(futures);
  return languages.whereType<UserLanguage>().toList();
});