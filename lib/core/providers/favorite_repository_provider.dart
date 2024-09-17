import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/repositories/favorite_repository.dart';
import 'package:lessay_learn/core/services/favorite_service.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return FavoriteRepository(localStorageService);
});

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return FavoriteService(repository);
});

final favoritesProvider = FutureProvider<List<FavoriteModel>>((ref) async {
  final service = ref.watch(favoriteServiceProvider);
  return await service.getFavorites();
});
final favoritesByUserAndLanguageProvider = FutureProvider.family<List<FavoriteModel>, (String, String)>((ref, params) async {
  final service = ref.watch(favoriteServiceProvider);
  return await service.getFavoritesByUserAndLanguage(params.$1, params.$2);
});