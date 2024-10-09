import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/providers/auth_provider.dart';
import 'package:lessay_learn/core/auth/services/sign_up_service.dart';
import 'package:lessay_learn/core/providers/user_provider.dart' as user_provider;
// import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

final signUpProvider = StateNotifierProvider<SignUpNotifier, AsyncValue<UserModel>>((ref) {
  final userService = ref.watch(user_provider.userServiceProvider); // Assuming you have a userServiceProvider
  final firebaseService = ref.watch(firebaseServiceProvider); // Assuming you have a firebaseServiceProvider
  return SignUpNotifier(SignUpService(userService, firebaseService), ref);
});



class SignUpNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final SignUpService _signUpService;
final Ref _ref;

 SignUpNotifier(this._signUpService, this._ref) : super(const AsyncValue.loading());

  Future<void> completeSignUp(UserModel user) async {
    state = const AsyncValue.loading();
    try {
      final updatedUser = await _signUpService.completeSignUp(user);
      state = AsyncValue.data(updatedUser);
      
      // Update the current user provider
      _ref.read(user_provider.currentUserProvider.notifier).updateUser(updatedUser);
      
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}