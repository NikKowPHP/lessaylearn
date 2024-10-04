import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lessay_learn/features/voicer/models/recording_model.dart';
import 'package:lessay_learn/features/voicer/services/recording_service.dart';

import 'package:lessay_learn/core/providers/language_provider.dart';

final recordingServiceProvider = Provider<RecordingService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return RecordingService(localStorageService);
});

final userRecordingsProvider = FutureProvider.family<List<RecordingModel>, String>((ref, userId) async {
  final recordingService = ref.watch(recordingServiceProvider);
  return await recordingService.getRecordingsForUser(userId);
});

final userLanguageRecordingsProvider = FutureProvider.family<List<RecordingModel>, (String, String)>((ref, params) async {
  final recordingService = ref.watch(recordingServiceProvider);
  final (userId, languageId) = params;
  return await recordingService.getRecordingsForUserAndLanguage(userId, languageId);
});