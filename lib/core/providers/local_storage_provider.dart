import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

final localStorageServiceProvider = Provider<ILocalStorageService>((ref) {
  return LocalStorageService(); // Or your specific implementation
});