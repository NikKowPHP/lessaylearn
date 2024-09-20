import 'package:flutter_tts/flutter_tts.dart';
import 'package:lessay_learn/core/interfaces/tts_interface.dart';

class FlutterTtsService implements ITtsService {
  final FlutterTts _flutterTts = FlutterTts();

  FlutterTtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  @override
  Future<void> speak(String text, String language) async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _flutterTts.stop();
  }
}