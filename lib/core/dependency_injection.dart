import 'package:get_it/get_it.dart';
import 'package:lessay_learn/services/api_service.dart';
// Import other services or repositories here

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Register API Service only if it's not already registered
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }

  // Register other services or repositories here, using the same pattern
}