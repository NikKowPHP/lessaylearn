import 'package:translator/translator.dart';


class TranslationResult {
  final String translatedText;
  final String detectedLanguage;

  TranslationResult(this.translatedText, this.detectedLanguage);
}

abstract class ITranslateService {
  Future<TranslationResult> translate(String text, String targetLanguage);
}



class TranslateService implements ITranslateService {
  final GoogleTranslator _translator = GoogleTranslator();

  @override
  Future<TranslationResult> translate(String text, String targetLanguage) async {
    try {
      final translation = await _translator.translate(text, to: targetLanguage);
      return TranslationResult(translation.text, translation.sourceLanguage.code);
    } catch (e) {
      print('Translation error: $e');
      return TranslationResult(text, 'unknown'); // Return original text if translation fails
    }
  }
}