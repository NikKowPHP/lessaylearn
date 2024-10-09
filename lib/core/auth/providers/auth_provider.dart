import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/services/auth_service.dart';
import 'package:lessay_learn/core/data/data_sources/mock_firebase_service.dart';

import 'package:lessay_learn/core/data/data_sources/storage/firebase_service.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:lessay_learn/services/user_service.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());


// final mockFirebaseServiceProvider = Provider<IFirebaseService>((ref) => MockFirebaseService());
final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  final localStorageService = ref.watch(localStorageServiceProvider);
  final userService = ref.watch(userServiceProvider); // Add user service
  return AuthService(firebaseService, localStorageService, userService); // Pass user service to AuthService
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.onAuthStateChanged;
});

// final authStateProvider = FutureProvider<UserModel?>((ref) async {
// final currentUser = ref.watch(currentUserProvider).value;
  
  
//   return currentUser; 
// });


final isLoadingProvider = StateProvider<bool>((ref) => false);

final authErrorProvider = StateProvider<String?>((ref) => null);