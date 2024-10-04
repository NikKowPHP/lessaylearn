import 'package:translator/translator.dart';

abstract class ITranslateService {
  Future<String> translate(String text, String targetLanguage);
}

class TranslateService implements ITranslateService {
  final GoogleTranslator _translator = GoogleTranslator();

  @override
  Future<String> translate(String text, String targetLanguage) async {
    try {
      final translation = await _translator.translate(text, to: targetLanguage);
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text if translation fails
    }
  }
}