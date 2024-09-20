import '../core/interfaces/storage_interface.dart';
import '../data/data_sources/storage/hive_storage.dart';

enum StorageType { hive, firebase }

class StorageService {
  final StorageType _storageType;

  StorageService(this._storageType);

  IStorage<T> getStorage<T>(String boxName) {
    switch (_storageType) {
      case StorageType.hive:
        return HiveStorage<T>(boxName);
      case StorageType.firebase:
        // TODO: Implement Firebase storage
        throw UnimplementedError('Firebase storage not implemented yet');
    }
  }
}