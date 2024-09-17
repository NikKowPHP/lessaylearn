import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/i_user_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class UserService implements IUserService {
  final ILocalStorageService _localStorageService;

  UserService(this._localStorageService);

  @override
  Future<UserModel> getCurrentUser() async {
    // TODO: Implement this based on your authentication system
    // For now, we'll just return a mock user
     UserModel? user = await _localStorageService.getCurrentUser();
    
    // If no user is found, return a default user
    if (user == null) {
      user = UserModel(
        id: 'currentUser',
        name: 'John Doe',
        avatarUrl: 'assets/avatar-1.png',
        languageLevel: 'Intermediate',
          sourceLanguageIds: ['lang_en'], // Replace with actual language IDs
        targetLanguageIds: ['lang_es'], // Replace with actual language IDs
        spokenLanguageIds: ['lang_en', 'lang_es'], // Replace with actual language IDs
        location: 'New York',
        age: 28,
        bio: 'Language enthusiast',
        interests: ['Reading', 'Traveling'],
        occupation: 'Software Developer',
        education: 'Bachelor in Computer Science',
         languageIds: ['lang_en', 'lang_es'],
      );
      await _localStorageService.saveUser(user);
    }
    return user;
  }
  @override
  Future<void> updateUser(UserModel user) async {
    await _localStorageService.saveUser(user);
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    return _localStorageService.getUserById(userId);
  }
  
}