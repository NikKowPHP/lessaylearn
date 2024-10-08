// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:lessay_learn/core/data/data_sources/storage/firebase_service.dart';

// class MockFirebaseService implements FirebaseService {
//   @override
//   Future<firebase_auth.User?> signInWithEmailAndPassword(String email, String password) async {
//     // Mock implementation - return a mock user or null
//     return null; // Or return a mock user object if needed for testing
//   }

//   @override
//   Future<firebase_auth.User?> registerWithEmailAndPassword(String email, String password) async {
//     return null; // Or return a mock user object
//   }

//   @override
//   Future<firebase_auth.User?> signInWithGoogle() async {
//     return null; // Or return a mock user object
//   }

//   @override
//   Future<void> signOut() async {}

//   @override
//   firebase_auth.User? getCurrentUser() {
//     // Return a mock user or null based on your local storage check
//     return null; // Or return a mock user object
//   }

//   @override
//   Stream<firebase_auth.User?> get onAuthStateChanged => Stream.value(null); // Or a mock stream
// }