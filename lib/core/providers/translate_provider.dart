import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/services/translate_service.dart';

final translateServiceProvider = Provider<ITranslateService>((ref) {
  return TranslateService();
});

final translateProvider = FutureProvider.family<TranslationResult, TranslateParams>((ref, params) async {
  final translateService = ref.watch(translateServiceProvider);
  return translateService.translate(params.text, params.targetLanguage);
});

class TranslateParams {
  final String text;
  final String targetLanguage;

  TranslateParams({required this.text, required this.targetLanguage});
}