import 'package:firebase_auth/firebase_auth.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Stream<UserModel?> get user => _auth.authStateChanges().asyncMap((user) =>
      user != null ? _firestoreService.getUser(user.uid) : null);

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user == null) return null;
      return await _firestoreService.getUser(user.uid);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModel?> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user == null) return null;

      UserModel newUser = UserModel(
        uid: user.uid,
        name: name,
        email: email,
      );
      await _firestoreService.createUser(newUser);
      return newUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
