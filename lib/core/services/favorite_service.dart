import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

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
}