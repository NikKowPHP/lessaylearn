import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/comment_model.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/models/like_model.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';
import 'package:lessay_learn/services/i_user_service.dart';
import 'package:lessay_learn/services/user_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

final updateUserProvider = Provider<Future<void> Function(UserModel)>((ref) {
  final userService = ref.watch(userServiceProvider);
  return (UserModel updatedUser) async {
    await userService.updateUser(updatedUser);
    // Invalidate the currentUserProvider to force a refresh
    ref.invalidate(currentUserProvider);
  };
});

// Provider for IUserService
final userServiceProvider = Provider<IUserService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return UserService(localStorageService);
});

// Provider for current user
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<UserModel>>((ref) {
  final userService = ref.watch(userServiceProvider);
  return CurrentUserNotifier(userService);
});
// Provider to fetch a user by ID
final userByIdProvider =
    FutureProvider.family<UserModel?, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getUserById(userId);
});

final userProfilePicturesProvider =
    FutureProvider.family<List<ProfilePictureModel>, String>(
        (ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getUserProfilePictures(userId);
});

final likesForPictureProvider =
    FutureProvider.family<List<LikeModel>, String>((ref, pictureId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getLikesForPicture(pictureId);
});

final commentsForPictureProvider =
    FutureProvider.family<List<CommentModel>, String>((ref, pictureId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getCommentsForPicture(pictureId);
});

// New providers
final profilePictureByIdProvider =
    FutureProvider.family<ProfilePictureModel?, String>((ref, pictureId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getProfilePictureById(pictureId);
});

final userLikesProvider =
    FutureProvider.family<List<LikeModel>, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getUserLikes(userId);
});

final userCommentsProvider =
    FutureProvider.family<List<CommentModel>, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getUserComments(userId);
});
final userLanguagesProvider = FutureProvider.family<List<UserLanguage>, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserLanguages(userId);
});

class CurrentUserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final IUserService _userService;

  CurrentUserNotifier(this._userService) : super(AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    state = AsyncValue.loading();
    try {
      final user = await _userService.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    state = AsyncValue.loading();
    try {
      await _userService.updateUser(updatedUser);
      state = AsyncValue.data(updatedUser);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
