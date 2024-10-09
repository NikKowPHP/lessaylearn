
import 'package:firebase_core/firebase_core.dart';
import 'package:lessay_learn/core/data/data_sources/storage/firebase_service.dart';
import 'package:lessay_learn/core/models/comment_model.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/models/like_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';
import 'package:lessay_learn/features/statistics/models/chart_model.dart';
import 'package:lessay_learn/services/i_user_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<void> saveCurrentUser(UserModel user);
  Future<List<ChartModel>> getUserChart(String userId);
  Future<void> updateUserChart(ChartModel chart);
  Future<void> deleteUserChart(String chartId);
  Future<List<ChartModel>> getUserCharts(String userId);
Future<void> createUserIfNotExists(UserModel user); 
  Future<void> createUser(UserModel user);
}

class UserService implements IUserService {
  final ILocalStorageService _localStorageService;
  UserModel? _cachedCurrentUser;
final FirebaseService _firestoreService;


  UserService(this._localStorageService) : _firestoreService = FirebaseService();


  @override
 Future<void> createUser(UserModel user) async {
    try {
     
      // Save user data to Firestore
      await _firestoreService.addDocument('users', user.toJson());

      // Save user locally
      await _localStorageService.addUser(user);


    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  @override
  Future<void> createUserIfNotExists(UserModel user) async {
    try {
      // Check if the user exists in Firestore
      Map<String, dynamic>? userDoc = await _firestoreService.getDocument('users', user.id);
      if (userDoc == null) {
        // If the user does not exist, create a new user
        await createUser(user);
      } else {
        print('User already exists: ${user.id}');
      }
    } catch (e) {
      print('Error checking user existence: $e');
      rethrow;
    }
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

    Future<void> saveCurrentUser(UserModel user) async {

    _cachedCurrentUser = user; // Update the cached current user
    print('save current user $_cachedCurrentUser');
    await _localStorageService.saveCurrentUser(user);
  

  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      // Update user in Firestore
       await _firestoreService.updateDocument('users', user.id, user.toJson());
      // Update user locally
      await _localStorageService.saveUser(user);

      // Update cached current user
      _cachedCurrentUser = user;
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
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
