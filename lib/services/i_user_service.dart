import 'package:lessay_learn/core/models/comment_model.dart';
import 'package:lessay_learn/core/models/like_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';

abstract class IUserService {
   Future<UserModel> getCurrentUser();
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
}