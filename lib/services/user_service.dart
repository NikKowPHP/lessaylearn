import 'package:lessay_learn/core/models/comment_model.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/models/like_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';
import 'package:lessay_learn/features/statistics/models/chart_model.dart';
import 'package:lessay_learn/services/i_user_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

// import 'package:lessay_learn/services/i_local_storage_service.dart';
abstract class IUserService {
  Future<UserModel?> getCurrentUser();
  Future<void> updateUser(UserModel user);
  Future<UserModel?> getUserById(String userId);
  Future<List<ProfilePictureModel>> getUserProfilePictures(String userId);
  Future<void> addProfilePicture(ProfilePictureModel picture);
  Future<void> removeProfilePicture(String pictureId);
  Future<void> addLike(LikeModel like);
  Future<void> removeLike(String likeId);
  Future<void> addComment(CommentModel comment);
  Future<void> removeComment(String commentId);
  Future<List<LikeModel>> getLikesForPicture(String pictureId);
  Future<List<CommentModel>> getCommentsForPicture(String pictureId);

  // New methods
  Future<ProfilePictureModel?> getProfilePictureById(String pictureId);
  Future<List<LikeModel>> getUserLikes(String userId);
  Future<List<CommentModel>> getUserComments(String userId);
  Future<List<UserLanguage>> getUserLanguages(String userId);

  // chart operations
  // Chart operations
  Future<void> saveUserChart(ChartModel chart);
  Future<List<ChartModel>> getUserChart(String userId);
  Future<void> updateUserChart(ChartModel chart);
  Future<void> deleteUserChart(String chartId);
  Future<List<ChartModel>> getUserCharts(String userId);

  Future<void> createUser(UserModel user);
}

class UserService implements IUserService {
  final ILocalStorageService _localStorageService;
  UserModel? _cachedCurrentUser;
  UserService(this._localStorageService);

  @override
  Future<void> createUser(UserModel user) async {
    await _localStorageService.addUser(user);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_cachedCurrentUser != null) {
      return _cachedCurrentUser!;
    }

    UserModel? user = await _localStorageService.getCurrentUser();
    _cachedCurrentUser = user;
    return user;
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _localStorageService.saveUser(user);
  }

  @override
  Future<void> saveUserChart(ChartModel chart) async {
    await _localStorageService.saveChart(chart);
  }

  @override
  Future<List<ChartModel>> getUserChart(String userId) async {
    return await _localStorageService.getUserCharts(userId);
  }

  @override
  Future<void> updateUserChart(ChartModel chart) async {
    await _localStorageService.updateChart(chart);
  }

  @override
  Future<void> deleteUserChart(String chartId) async {
    await _localStorageService.deleteChart(chartId);
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    return _localStorageService.getUserById(userId);
  }

  @override
  Future<List<ProfilePictureModel>> getUserProfilePictures(
      String userId) async {
    return await _localStorageService.getProfilePicturesForUser(userId);
  }

  @override
  Future<void> addProfilePicture(ProfilePictureModel picture) async {
    await _localStorageService.saveProfilePicture(picture);
  }

  @override
  Future<void> removeProfilePicture(String pictureId) async {
    await _localStorageService.deleteProfilePicture(pictureId);
  }

  @override
  Future<void> addLike(LikeModel like) async {
    await _localStorageService.saveLike(like);
  }

  @override
  Future<void> removeLike(String likeId) async {
    await _localStorageService.deleteLike(likeId);
  }

  @override
  Future<void> addComment(CommentModel comment) async {
    await _localStorageService.saveComment(comment);
  }

  @override
  Future<void> removeComment(String commentId) async {
    await _localStorageService.deleteComment(commentId);
  }

  @override
  Future<List<LikeModel>> getLikesForPicture(String pictureId) async {
    return await _localStorageService.getLikesForPicture(pictureId);
  }

  @override
  Future<List<CommentModel>> getCommentsForPicture(String pictureId) async {
    return await _localStorageService.getCommentsForPicture(pictureId);
  }

  @override
  Future<ProfilePictureModel?> getProfilePictureById(String pictureId) async {
    return await _localStorageService.getProfilePictureById(pictureId);
  }

  @override
  Future<List<LikeModel>> getUserLikes(String userId) async {
    final allLikes = await _localStorageService.getLikes();
    return allLikes.where((like) => like.userId == userId).toList();
  }

  @override
  Future<List<CommentModel>> getUserComments(String userId) async {
    final allComments = await _localStorageService.getComments();
    return allComments.where((comment) => comment.userId == userId).toList();
  }

  @override
  Future<List<UserLanguage>> getUserLanguages(String userId) async {
    // Fetch the user by ID
    UserModel? user = await getUserById(userId);
    if (user != null) {
      // Retrieve languages from local storage based on userId
      return await _localStorageService.getUserLanguagesByUserId(userId);
    }
    return []; // Return an empty list if user is not found
  }

  @override
  Future<List<ChartModel>> getUserCharts(String userId) async {
    return await _localStorageService.getUserCharts(userId);
  }
}
