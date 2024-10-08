import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/user_language_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/onboarding/services/onboarding_service.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final userService = ref.watch(userServiceProvider);
  final localStorageService = ref.watch(localStorageServiceProvider);
  return OnboardingService(userService, localStorageService);
});

final onboardingUserProvider = StateNotifierProvider<OnboardingUserNotifier, UserModel>((ref) {
  return OnboardingUserNotifier();
});

final profilePictureProvider = StateProvider<ProfilePictureModel?>((ref) => null);


class OnboardingUserNotifier extends StateNotifier<UserModel> {
  OnboardingUserNotifier() : super(UserModel.empty());

  void updateUser(UserModel user) {
    state = user;
  }

  void updateAvatar(String avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }
}