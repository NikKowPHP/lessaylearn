import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/services/auth_service.dart';
import 'package:lessay_learn/core/data/data_sources/mock_firebase_service.dart';

import 'package:lessay_learn/core/data/data_sources/storage/firebase_service.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());
final mockFirebaseServiceProvider = Provider<IFirebaseService>((ref) => MockFirebaseService());
final authServiceProvider = Provider<AuthService>((ref) {
  // final firebaseService = ref.watch(firebaseServiceProvider);
    final firebaseService = ref.watch(mockFirebaseServiceProvider);
  final localStorageService = ref.watch(localStorageServiceProvider);
  return AuthService(firebaseService, localStorageService);
});

// final authStateProvider = StreamProvider<UserModel?>((ref) {
//   final authService = ref.watch(authServiceProvider);
//   return authService.onAuthStateChanged;
//   return currentUserProvider()
// });

final authStateProvider = FutureProvider<UserModel?>((ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  // You might want to handle the case where currentUser is null:
  debugPrint('current user $currentUser');
  return currentUser; // Or return a default user or handle the null case appropriately
});


final isLoadingProvider = StateProvider<bool>((ref) => false);

final authErrorProvider = StateProvider<String?>((ref) => null);