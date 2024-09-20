import 'package:lessay_learn/core/interfaces/storage_interface.dart';

import '../../core/models/favorite_model.dart';
import '../../services/storage_service.dart';

class FavoriteRepository {
  final StorageService _storageService;

  FavoriteRepository(this._storageService);

  IStorage<FavoriteModel> get _storage => _storageService.getStorage<FavoriteModel>('favorites');

  Future<void> saveFavorite(FavoriteModel favorite) => _storage.create(favorite.id, favorite);
  Future<List<FavoriteModel>> getFavorites() => _storage.readAll();
  Future<void> deleteFavorite(String favoriteId) => _storage.delete(favoriteId);

  Future<List<FavoriteModel>> getFavoritesByUserAndLanguage(String userId, String languageId) {
    return _storage.query((fav) => fav.userId == userId && fav.targetLanguage == languageId);
  }
}