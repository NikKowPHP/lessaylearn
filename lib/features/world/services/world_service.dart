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
  return _filterUsersBySegment(savedUsers, segment);
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

}