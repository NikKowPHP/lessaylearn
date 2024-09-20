// lib/services/database_service.dart

import '../data/repositories/user_repository.dart';
import '../data/repositories/known_word_repository.dart';
import '../data/repositories/favorite_repository.dart';
import 'storage_service.dart';

class DatabaseService {
  final StorageService _storageService;
  late final UserRepository userRepository;
  late final KnownWordRepository knownWordRepository;
  late final FavoriteRepository favoriteRepository;

  DatabaseService(StorageType storageType) : _storageService = StorageService(storageType) {
    userRepository = UserRepository(_storageService);
    knownWordRepository = KnownWordRepository(_storageService);
    favoriteRepository = FavoriteRepository(_storageService);
  }

  // High-level database operations can be defined here
}