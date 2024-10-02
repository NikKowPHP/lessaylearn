import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/user_service.dart';
import 'package:flutter/foundation.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return UserService(localStorageService);
});

final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final userService = ref.watch(userServiceProvider);
  final currentUser = await userService.getCurrentUser();
  debugPrint('currentUserProvider $currentUser');
  return userService.getCurrentUser();
});

final userLanguagesProvider = FutureProvider.family<List<LanguageModel>, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserLanguages(userId);
});