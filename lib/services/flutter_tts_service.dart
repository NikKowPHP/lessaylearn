import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'package:lessay_learn/core/interfaces/tts_interface.dart';

class FlutterTtsService implements ITtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  FlutterTtsService();

  @override
  Future<void> initialize() async {
    if (!_isInitialized) {
      await _initTts();
    }
  }

  Future<void> _initTts() async {
    try {
      if (await _flutterTts.isLanguageAvailable("en-US")) {
        await _flutterTts.setLanguage("en-US");
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setVolume(1.0);
        await _flutterTts.setPitch(1.0);
        _isInitialized = true;
      } else {
        debugPrint("English language is not available on this device");
      }
    } catch (e) {
      debugPrint("Failed to initialize TTS: $e");
    }
  }

  @override
  Future<void> speak(String text, String language) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (await _flutterTts.isLanguageAvailable(language)) {
        await _flutterTts.setLanguage(language);
        await _flutterTts.speak(text);
      } else {
        debugPrint("Language $language is not available, falling back to English");
        await _flutterTts.setLanguage("en-US");
        await _flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint("Failed to speak: $e");
    }
  }

  @override
  Future<void> stop() async {
    if (_isInitialized) {
      await _flutterTts.stop();
    }
  }
}