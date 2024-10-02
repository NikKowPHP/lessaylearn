import 'package:firebase_auth/firebase_auth.dart';
import 'package:lessay_learn/core/data/data_sources/mock_firebase_service.dart';
import 'package:lessay_learn/core/data/data_sources/storage/firebase_service.dart';

import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

class AuthService {
  final IFirebaseService _firebaseService;
  final ILocalStorageService _localStorageService;

  AuthService(this._firebaseService, this._localStorageService);

  Future<UserModel?> signIn(String email, String password) async {
    final User? user = await _firebaseService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      return _getUserModel(user);
    }
    return null;
  }

  Future<UserModel?> register(String email, String password, String name) async {
    final User? user = await _firebaseService.registerWithEmailAndPassword(email, password);
    if (user != null) {
      final newUser = UserModel(
        id: user.uid,
        email: user.email!,
        name: name,
      );
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

  Future<UserModel> _getUserModel(User user) async {
    UserModel? userModel = await _localStorageService.getUserById(user.uid);
    if (userModel == null) {
      userModel = UserModel(
        id: user.uid,
        email: user.email!,
        name: user.displayName ?? user.email!.split('@')[0],
      );
      await _localStorageService.saveUser(userModel);
    }
    return userModel;
  }

  Future<void> updateUser(UserModel user) async {
    await _localStorageService.updateUser(user);
  }
}