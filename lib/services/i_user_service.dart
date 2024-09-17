import 'package:lessay_learn/features/chat/models/user_model.dart';

abstract class IUserService {
  Future<UserModel> getCurrentUser();
  Future<void> updateUser(UserModel user);

  Future<UserModel?> getUserById(String userId);
}