import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

final currentUserProvider = Provider<UserModel>((ref) {
  // Replace this with actual user authentication logic
  return UserModel(
    id: 'user1',
    name: 'Current User',
    avatarUrl: 'https://example.com/avatar.jpg',
    languageLevel: 'Intermediate',
    sourceLanguage: 'English',
    targetLanguage: 'Spanish',
    location: 'New York',
    age: 25,
  );
}); 