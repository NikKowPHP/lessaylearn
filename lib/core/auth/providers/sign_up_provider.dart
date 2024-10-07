import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/services/sign_up_service.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

final signUpProvider = StateNotifierProvider<SignUpNotifier, AsyncValue<UserModel>>((ref) {
  return SignUpNotifier(SignUpService());
});

class SignUpNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final SignUpService _signUpService;

  SignUpNotifier(this._signUpService) : super(const AsyncValue.loading());

  Future<void> completeSignUp(UserModel user) async {
    state = const AsyncValue.loading();
    try {
      await _signUpService.completeSignUp(user);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}