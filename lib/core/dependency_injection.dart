import 'package:get_it/get_it.dart';
import 'package:lessay_learn/core/app_config.dart';
import 'package:lessay_learn/core/services/favorite_service.dart';
import 'package:lessay_learn/core/services/known_word_service.dart';
import 'package:lessay_learn/data/repositories/favorite_repository.dart';
import 'package:lessay_learn/data/repositories/known_word_repository.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';
import 'package:lessay_learn/services/api_service.dart';
// import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }
  if (!getIt.isRegistered<ILocalStorageService>()) {
    getIt.registerLazySingleton<ILocalStorageService>(() => LocalStorageService());
  }

  if (!getIt.isRegistered<IChatService>()) {
    getIt.registerLazySingleton<IChatService>(() => ChatService(getIt()));
  }

  if (!getIt.isRegistered<IAppConfig>()) {
    getIt.registerLazySingleton<IAppConfig>(() => AppConfig());
  }
  // Register repositories
  if (!getIt.isRegistered<FavoriteRepository>()) {
    getIt.registerLazySingleton<FavoriteRepository>(() => FavoriteRepository(getIt()));
  }
  if (!getIt.isRegistered<KnownWordRepository>()) {
    getIt.registerLazySingleton<KnownWordRepository>(() => KnownWordRepository(getIt()));
  }

  // Register services
  if (!getIt.isRegistered<FavoriteService>()) {
    getIt.registerLazySingleton<FavoriteService>(() => FavoriteService(getIt()));
  }
  if (!getIt.isRegistered<KnownWordService>()) {
    getIt.registerLazySingleton<KnownWordService>(() => KnownWordService(getIt()));
  }
}
