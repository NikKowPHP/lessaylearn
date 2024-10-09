import 'package:lessay_learn/core/data/data_sources/storage/firebase_service.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

import 'package:lessay_learn/services/user_service.dart';


class SignUpService {
  final IUserService _userService;
  final IFirebaseService _firebaseService;

  SignUpService(this._userService, this._firebaseService);

  Future<UserModel> completeSignUp(UserModel user) async {
    // Save user to Firebase
   await _firebaseService.updateDocumentByField(
      'users',
      'id', // Assuming 'id' is the field you want to match
      user.id,
      user.toJson() // Use toJson to convert UserModel to Map
    );
    
    // Save user locally
    await _userService.saveCurrentUser(user);
    
    return user; // Return the user model after saving
  }
}