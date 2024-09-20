import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/services/favorite_service.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return FavoriteService(localStorageService);
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteModel>>((ref) {
  final service = ref.watch(favoriteServiceProvider);
  return FavoritesNotifier(service, ref);
});

final favoritesByUserAndLanguageProvider = FutureProvider.autoDispose.family<List<FavoriteModel>, (String, String)>((ref, params) async {
  final service = ref.watch(favoriteServiceProvider);
  return await service.getFavoritesByUserAndLanguage(params.$1, params.$2);
});

class FavoritesNotifier extends StateNotifier<List<FavoriteModel>> {
  final FavoriteService _service;
  final Ref _ref;

  FavoritesNotifier(this._service, this._ref) : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _service.getFavorites();
    state = favorites;
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    await _service.addFavorite(favorite);
    state = [...state, favorite];
    _ref.invalidate(favoritesByUserAndLanguageProvider);
  }

  Future<void> removeFavorite(String favoriteId) async {
    await _service.removeFavorite(favoriteId);
    state = state.where((favorite) => favorite.id != favoriteId).toList();
    _ref.invalidate(favoritesByUserAndLanguageProvider);
  }
}