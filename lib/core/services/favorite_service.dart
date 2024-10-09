import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

class FavoriteService {
  final ILocalStorageService _localStorageService;

  FavoriteService(this._localStorageService);

  Future<void> addFavorite(FavoriteModel favorite) async {
    await _localStorageService.saveFavorite(favorite);
  }

  Future<List<FavoriteModel>> getFavorites() async {
    return await _localStorageService.getFavorites();
  }

  Future<void> removeFavorite(String favoriteId) async {
    await _localStorageService.deleteFavorite(favoriteId);
  }

  Future<List<FavoriteModel>> getFavoritesByUserAndLanguage(String userId, String languageId) async {
    return await _localStorageService.getFavoritesByUserAndLanguage(userId, languageId);
  }
    Future<List<FavoriteModel>> getAvailableFavoritesByLanguage(String sourceLanguage, String targetLanguage) async {
        // Assuming your FavoriteModel has sourceLanguage and targetLanguage properties
        final allFavorites = await _localStorageService.getFavorites();
        return allFavorites.where((favorite) =>
            favorite.sourceLanguageId == sourceLanguage &&
            favorite.targetLanguageId == targetLanguage).toList();
        
    }

}