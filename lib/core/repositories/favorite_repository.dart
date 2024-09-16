import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class FavoriteRepository {
  final ILocalStorageService _localStorageService;

  FavoriteRepository(this._localStorageService);

  Future<void> saveFavorite(FavoriteModel favorite) async {
    await _localStorageService.saveFavorite(favorite);
  }

  Future<List<FavoriteModel>> getFavorites() async {
    return await _localStorageService.getFavorites();
  }

  Future<void> deleteFavorite(String favoriteId) async {
    await _localStorageService.deleteFavorite(favoriteId);
  }
}