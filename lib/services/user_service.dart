import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/i_user_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class UserService implements IUserService {
  final ILocalStorageService _localStorageService;

  UserService(this._localStorageService);

  @override
  Future<UserModel> getCurrentUser() async {
    // Implement this based on your authentication system
    // For now, we'll just return a mock user
    return UserModel(
      id: 'currentUser',
      name: 'John Doe',
      avatarUrl: 'https://example.com/avatar.jpg',
      languageLevel: 'Intermediate',
      sourceLanguage: 'English',
      targetLanguage: 'Spanish',
      location: 'New York',
      age: 28,
    );
  }

  @override
  Future<void> updateUser(UserModel user) async {
    // Implement user update logic
    await _localStorageService.saveUser(user);
  }
}