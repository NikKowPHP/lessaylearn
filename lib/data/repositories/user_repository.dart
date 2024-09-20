import 'package:lessay_learn/core/interfaces/storage_interface.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';


import '../../services/storage_service.dart';

class UserRepository {
  final StorageService _storageService;

  UserRepository(this._storageService);

  IStorage<UserModel> get _storage => _storageService.getStorage<UserModel>('users');

  Future<void> saveUser(UserModel user) => _storage.create(user.id, user);
  Future<UserModel?> getUserById(String id) => _storage.read(id);
  Future<List<UserModel>> getAllUsers() => _storage.readAll();
  Future<void> updateUser(UserModel user) => _storage.update(user.id, user);
  Future<void> deleteUser(String id) => _storage.delete(id);
}