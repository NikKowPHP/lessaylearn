import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:lessay_learn/services/user_service.dart';
import 'dart:html' as html;

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
    try {
      // Fetch the current user
      final currentUser = await _userService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('No current user found');
      }

print('current user ${user.id}');
      // Update the user with new data
      final updatedUser = currentUser.copyWith(
        id: currentUser.id,
        name: user.name,
        avatarUrl: user.avatarUrl,
        sourceLanguageIds: user.sourceLanguageIds,
        targetLanguageIds: user.targetLanguageIds,
        spokenLanguageIds: user.spokenLanguageIds,
        interests: user.interests,
        location: user.location,
        age: user.age,
        bio: user.bio,
        occupation: user.occupation,
        education: user.education,
        languageIds: user.languageIds,
      );

      // Save the updated user
      // await _userService.updateUser(updatedUser);

      print('Registration completed for user: ${updatedUser.id}');
    } catch (e) {
      print('Error completing registration: $e');
      rethrow;
    }
  }

  Future<String?> getUserCity() async {
    if (kIsWeb) {
      try {
        final geolocation = html.window.navigator.geolocation;
        final position = await geolocation.getCurrentPosition();
        final latitude = position.coords!.latitude!.toDouble();
        final longitude = position.coords!.longitude!.toDouble();

        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latitude, longitude);

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            final city =
                place.locality ?? place.subLocality ?? place.administrativeArea;
            return city;
          } else {
            print('No placemarks found for coordinates.');
          }
        } catch (e) {
          // TODO: IMPLEMENT THE GEO FOR WEB
          print('Error in placemarkFromCoordinates: $e');
          // Fallback: Use an alternative geocoding service (e.g., Google Maps)
          return null;
        }
      } catch (e) {
        print('Error getting user location on web: $e');
        return null;
      }
    } else {
      // Handle mobile location access using geolocator
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return null;
          }
        }

        Position position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          return place.locality ??
              place.subLocality ??
              place.administrativeArea;
        }
      } catch (e) {
        print('Error getting user location on mobile: $e');
      }
      return null;
    }
    return null;
  }
}
