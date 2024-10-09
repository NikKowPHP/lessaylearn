import 'package:firebase_auth/firebase_auth.dart';
import 'package:lessay_learn/core/data/data_sources/storage/firebase_service.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessay_learn/services/user_service.dart';

class AuthService {
  final IFirebaseService _firebaseService;
  final ILocalStorageService _localStorageService;
  final IUserService _userService;

  AuthService(
      this._firebaseService, this._localStorageService, this._userService);

  Future<UserModel?> signIn(String email, String password) async {
    final User? user =
        await _firebaseService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      // Check if the user exists in Firestore and create if not
      await _userService.createUserIfNotExists(UserModel(
        id: user.uid,
        email: user.email!,
        name: user.displayName ?? user.email!.split('@')[0],
      ));
      return _getUserModel(user);
    }
    return null;
  }

  Future<UserModel?> register(
      String email, String password, String name) async {
    final User? user =
        await _firebaseService.registerWithEmailAndPassword(email, password);
    if (user != null) {
      final newUser = UserModel(
        id: user.uid,
        email: user.email!,
        name: name,
      );
      await _userService
          .createUserIfNotExists(newUser); // Check and create user in Firestore
      await _localStorageService.saveUser(newUser);
      return newUser;
    }
    return null;
  }

  Future<UserModel?> signInWithGoogle() async {
    final User? user = await _firebaseService.signInWithGoogle();
    if (user != null) {
      return _getUserModel(user);
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    await _localStorageService.clearCurrentUser();
  }

  Future<UserModel?> getCurrentUser() async {
    final User? user = _firebaseService.getCurrentUser();
    if (user != null) {
      return _getUserModel(user);
    }
    return null;
  }

  // Updated onAuthStateChanged to handle async properly
  Stream<UserModel?> get onAuthStateChanged async* {
    await for (final User? user in _firebaseService.onAuthStateChanged) {
      if (user != null) {
        yield await _getUserModel(user);
      } else {
        yield null;
      }
    }
  }
 Future<void> fetchAndPrintAllUsers() async {
    try {
      List<UserModel> users = await _localStorageService.getAllUsers();
      for (var user in users) {
        print(user); // This will call the toString method of UserModel
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
  Future<UserModel> _getUserModel(User user) async {
    print('user from firebase ${user.uid}');
    UserModel? userModel = await _localStorageService.getUserById(user.uid);
    await fetchAndPrintAllUsers();
    print('logging in user in db ${userModel}');
    if (userModel == null) {
      userModel = UserModel(
        id: user.uid,
        email: user.email!,
        name: user.displayName ?? user.email!.split('@')[0],
      );
      await _localStorageService.saveUser(userModel);
    }
    await _userService.saveCurrentUser(userModel);
    return userModel;
  }

  Future<void> updateUser(UserModel user) async {
    await _localStorageService.updateUser(user);
  }
}
