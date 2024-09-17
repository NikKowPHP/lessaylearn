import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return UserService(localStorageService);
});

final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getCurrentUser();
});
final userLanguagesProvider = FutureProvider.family<List<LanguageModel>, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserLanguages(userId);
});