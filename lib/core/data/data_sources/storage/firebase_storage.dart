// lib/data/data_sources/storage/firebase_storage.dart



// import 'package:lessay_learn/core/interfaces/storage_interface.dart';

// class FirebaseStorage<T> implements IStorage<T> {
//   final String _collection;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   FirebaseStorage(this._collection);

//   @override
//   Future<void> create(String id, T item) async {
//     await _firestore.collection(_collection).doc(id).set(item as Map<String, dynamic>);
//   }

//   // Implement other CRUD methods...
// }