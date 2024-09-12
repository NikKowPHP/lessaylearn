import 'dart:math';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';


// Interfaces
abstract class ICommunityService {
  Future<List<UserModel>> getUsers(int segment);
}

abstract class ILocalStorageService {
  Future<List<UserModel>> getUsers();
  Future<void> saveUsers(List<UserModel> users);
}

// User Filter Strategy
abstract class IUserFilterStrategy {
  List<UserModel> filterUsers(List<UserModel> users);
}

class NearbyUserFilter implements IUserFilterStrategy {
  @override
  List<UserModel> filterUsers(List<UserModel> users) {
    return users.where((user) => user.location == 'Nearby City').toList();
  }
}

class MapUserFilter implements IUserFilterStrategy {
  @override
  List<UserModel> filterUsers(List<UserModel> users) {
    // In a real app, you'd implement map-based filtering here
    return users;
  }
}

class AllUserFilter implements IUserFilterStrategy {
  @override
  List<UserModel> filterUsers(List<UserModel> users) {
    return users;
  }
}



class CommunityService implements ICommunityService {
  final LocalStorageService localStorageService;

  CommunityService(this.localStorageService);

  @override
  Future<List<UserModel>> getUsers(int segment) async {
    final savedUsers = await localStorageService.getUsers();
    if (savedUsers.isNotEmpty) {
      return _filterUsersBySegment(savedUsers, segment);
    } else {
      final mockUsers = _getMockUsers();
      await localStorageService.saveUsers(mockUsers);
      return _filterUsersBySegment(mockUsers, segment);
    }
  }

  List<UserModel> _filterUsersBySegment(List<UserModel> users, int segment) {
    switch (segment) {
      case 1: // Nearby
        return users.where((user) => user.location == 'Nearby City').toList();
      case 2: // Map
        // In a real app, you'd implement map-based filtering here
        return users;
      default: // All
        return users;
    }
  }

  List<UserModel> _getMockUsers() {
    final random = Random();
    final List<UserModel> mockUsers = [];

    final List<String> names = ['John', 'Jane', 'Alice', 'Bob', 'Charlie', 'Diana'];
    final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
    final List<String> languages = ['English', 'Spanish', 'French', 'German', 'Italian', 'Chinese'];
    final List<String> locations = ['Nearby City', 'Far City', 'Another Country'];

    for (int i = 0; i < 20; i++) {
      String sourceLanguage = languages[random.nextInt(languages.length)];
      String targetLanguage;
      do {
        targetLanguage = languages[random.nextInt(languages.length)];
      } while (targetLanguage == sourceLanguage);

      mockUsers.add(UserModel(
        id: '${i + 1}',
        name: names[random.nextInt(names.length)],
        avatarUrl: 'assets/avatar_${random.nextInt(5) + 1}.png',
        languageLevel: levels[random.nextInt(levels.length)],
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        location: locations[random.nextInt(locations.length)],
        age: random.nextInt(30) + 18,
      ));
    }

    return mockUsers;
  }
}