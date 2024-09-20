import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/interfaces/tts_interface.dart';
import 'package:lessay_learn/services/flutter_tts_service.dart';

final ttsServiceProvider = Provider<ITtsService>((ref) {
  final ttsService = FlutterTtsService();
  ttsService.initialize(); // Initialize the service
  return ttsService;
});