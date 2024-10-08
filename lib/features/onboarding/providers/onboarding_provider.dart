import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/onboarding/services/onboarding_service.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService();
});

final onboardingUserProvider = StateNotifierProvider<OnboardingUserNotifier, UserModel>((ref) {
  return OnboardingUserNotifier();
});

class OnboardingUserNotifier extends StateNotifier<UserModel> {
  OnboardingUserNotifier() : super(UserModel.empty());

  void updateUser(UserModel user) {
    state = user;
  }

  void updateAvatar(String avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }
}