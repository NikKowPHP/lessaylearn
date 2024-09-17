import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/repositories/favorite_repository.dart';

class FavoriteService {
  final FavoriteRepository _repository;

  FavoriteService(this._repository);

  Future<void> addFavorite(FavoriteModel favorite) async {
    await _repository.saveFavorite(favorite);
  }

  Future<List<FavoriteModel>> getFavorites() async {
    return await _repository.getFavorites();
  }

  Future<void> removeFavorite(String favoriteId) async {
    await _repository.deleteFavorite(favoriteId);
  }

  // Add the missing method
  Future<List<FavoriteModel>> getFavoritesByUserAndLanguage(String userId, String languageId) async {
    return await _repository.getFavoritesByUserAndLanguage(userId, languageId);
  }
}