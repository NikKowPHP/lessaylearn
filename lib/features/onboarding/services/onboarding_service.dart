import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:lessay_learn/services/user_service.dart';

class OnboardingService {
  final IUserService _userService; // Inject IUserService
  final ILocalStorageService _localStorageService;

  OnboardingService(
      this._userService, this._localStorageService); // Constructor

   Future<ProfilePictureModel> saveAvatarLocally(dynamic avatarData) async {
    String base64Image;
    if (kIsWeb) {
      base64Image = avatarData as String;
    } else {
      final file = avatarData as File;
      final bytes = await file.readAsBytes();
      base64Image = base64Encode(bytes);
    }
    // Fetch the current user
    final currentUser = await _userService.getCurrentUser();

    final profilePicture = ProfilePictureModel(
      userId: currentUser?.id ?? '', // Use the fetched user ID
      base64Image: base64Image,
    );
    await _localStorageService.saveProfilePicture(profilePicture);
    return profilePicture;
  }

  Future<void> completeRegistration(UserModel user) async {
    // This method will be implemented later to save data to Firebase
    // For now, it's just a placeholder
    print('Registration completed for user: ${user.id}');
  }
}
