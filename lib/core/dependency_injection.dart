import 'package:get_it/get_it.dart';
import 'package:lessay_learn/core/app_config.dart';
import 'package:lessay_learn/core/repositories/favorite_repository.dart';
import 'package:lessay_learn/core/repositories/known_word_repository.dart';
import 'package:lessay_learn/core/services/favorite_service.dart';
import 'package:lessay_learn/core/services/known_word_service.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';
import 'package:lessay_learn/services/api_service.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }
  final localStorageService = LocalStorageService();
  await localStorageService.initializeBoxes();
  getIt
      .registerLazySingleton<ILocalStorageService>(() => LocalStorageService());

  getIt.registerLazySingleton<IChatService>(() => ChatService(getIt()));

  getIt.registerLazySingleton<IAppConfig>(() => AppConfig());
   // Register repositories
  getIt.registerLazySingleton<FavoriteRepository>(() => FavoriteRepository(getIt()));
  getIt.registerLazySingleton<KnownWordRepository>(() => KnownWordRepository(getIt()));

  // Register services
  getIt.registerLazySingleton<FavoriteService>(() => FavoriteService(getIt()));
  getIt.registerLazySingleton<KnownWordService>(() => KnownWordService(getIt()));

}
