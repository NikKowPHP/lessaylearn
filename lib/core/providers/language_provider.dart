import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/services/language_service.dart';


final languageServiceProvider = Provider<LanguageService>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return LanguageService(storageService);
});

final allLanguagesProvider = FutureProvider<List<Language>>((ref) async {
  final languageService = ref.watch(languageServiceProvider);
  return await languageService.getAllLanguages();
});