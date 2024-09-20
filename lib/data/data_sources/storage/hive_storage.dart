import 'package:hive/hive.dart';
import '../../../core/interfaces/storage_interface.dart';

class HiveStorage<T> implements IStorage<T> {
  final String _boxName;

  HiveStorage(this._boxName);

  Future<Box<T>> _openBox() async => await Hive.openBox<T>(_boxName);

  @override
  Future<void> create(String id, T item) async {
    final box = await _openBox();
    await box.put(id, item);
  }

  @override
  Future<T?> read(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  @override
  Future<List<T>> readAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<void> update(String id, T item) async {
    final box = await _openBox();
    await box.put(id, item);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<List<T>> query(bool Function(T) filter) async {
    final allItems = await readAll();
    return allItems.where(filter).toList();
  }
}