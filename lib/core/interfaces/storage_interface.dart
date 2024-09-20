// lib/core/interfaces/storage_interface.dart

abstract class IStorage<T> {
  Future<void> create(String id, T item);
  Future<T?> read(String id);
  Future<List<T>> readAll();
  Future<void> update(String id, T item);
  Future<void> delete(String id);
  Future<List<T>> query(bool Function(T) filter);
}