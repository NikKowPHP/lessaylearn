
import 'package:lessay_learn/features/voicer/models/recording_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class RecordingService {
  final ILocalStorageService _localStorageService;

  RecordingService(this._localStorageService);

  Future<void> saveRecording(RecordingModel recording) async {
    await _localStorageService.saveRecording(recording);
  }

  Future<List<RecordingModel>> getRecordingsForUser(String userId) async {
    return await _localStorageService.getRecordingsForUser(userId);
  }

  Future<List<RecordingModel>> getRecordingsForUserAndLanguage(String userId, String languageId) async {
    return await _localStorageService.getRecordingsForUserAndLanguage(userId, languageId);
  }

  Future<void> deleteRecording(String recordingId) async {
    await _localStorageService.deleteRecording(recordingId);
  }

  Future<void> updateRecording(RecordingModel recording) async {
    await _localStorageService.updateRecording(recording);
  }
}