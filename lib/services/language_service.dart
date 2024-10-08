import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

class LanguageService {
  final ILocalStorageService _storageService;

  LanguageService(this._storageService);

  Future<List<LanguageModel>> getAllLanguages() async {
    return await _storageService.getLanguages();
  }
}