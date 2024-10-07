import 'package:lessay_learn/features/chat/models/user_model.dart';

class SignUpService {
  Future<void> completeSignUp(UserModel user) async {
    // TODO: Implement the API call to save the user data
    // This is where you would typically make a network request to your backend
    await Future.delayed(const Duration(seconds: 2)); // Simulating network delay
    print('User sign up completed: ${user.toString()}');
  }
}