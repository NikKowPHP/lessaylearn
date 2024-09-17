import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/i_user_service.dart';
import 'package:lessay_learn/services/user_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

// Provider for IUserService
final userServiceProvider = Provider<IUserService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return UserService(localStorageService);
});

// Provider for current user
final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getCurrentUser();
});

// Provider to fetch a user by ID
final userByIdProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getUserById(userId);
});