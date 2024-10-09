import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class IFirebaseService {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> registerWithEmailAndPassword(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
  Stream<User?> get onAuthStateChanged;

   Future<void> addDocument(String collectionPath, Map<String, dynamic> data);
  Future<void> updateDocument(String collectionPath, String documentId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getDocument(String collectionPath, String documentId);
  Future<void> deleteDocument(String collectionPath, String documentId);
  Future<void> updateDocumentByField(String collectionPath, String field, String value, Map<String, dynamic> data);

}

class FirebaseService implements IFirebaseService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        return authResult.user;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get onAuthStateChanged => _auth.authStateChanges();



  // Firestore methods implementation

  @override
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  @override
  Future<void> updateDocument(String collectionPath, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      print('Error updating document: $e');
    }
  }
  @override
Future<void> updateDocumentByField(String collectionPath, String field, String value, Map<String, dynamic> data) async {
  try {
    // Find the document by the specified field
    final querySnapshot = await _firestore.collection(collectionPath)
        .where(field, isEqualTo: value)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Update the first document that matches the query
      await querySnapshot.docs.first.reference.update(data);
    } else {
      print('No document found with $field: $value');
    }
  } catch (e) {
    print('Error updating document: $e');
  }
}

  @override
  Future<Map<String, dynamic>?> getDocument(String collectionPath, String documentId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionPath).doc(documentId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting document: $e');
    }
    return null;
  }

  @override
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}