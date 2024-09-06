import 'package:get_it/get_it.dart';
import 'package:lessay_learn/core/app_config.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';
import 'package:lessay_learn/services/api_service.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
// Import other services or repositories here

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Register API Service only if it's not already registered
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }
  getIt
      .registerLazySingleton<ILocalStorageService>(() => LocalStorageService());

  // In your configureDependencies() function
  getIt.registerLazySingleton<IChatService>(() => ChatService(getIt()));

  // Register AppConfig
  getIt.registerLazySingleton<IAppConfig>(() => AppConfig());

  // Register other services or repositories here, using the same pattern
}
