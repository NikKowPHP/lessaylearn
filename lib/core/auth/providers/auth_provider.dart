import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/services/auth_service.dart';

import 'package:lessay_learn/core/data/data_sources/storage/firebase_storage.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  final localStorageService = ref.watch(localStorageServiceProvider);
  return AuthService(firebaseService, localStorageService);
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.onAuthStateChanged;
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
});