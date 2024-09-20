// lib/data/repositories/user_repository.dart

import 'package:lessay_learn/core/interfaces/storage_interface.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

class UserRepository {
  final IStorage<UserModel> _storage;

  UserRepository(this._storage);

  Future<void> saveUser(UserModel user) => _storage.create(user.id, user);
  Future<UserModel?> getUserById(String id) => _storage.read(id);
  Future<List<UserModel>> getAllUsers() => _storage.readAll();
  Future<void> updateUser(UserModel user) => _storage.update(user.id, user);
  Future<void> deleteUser(String id) => _storage.delete(id);
}