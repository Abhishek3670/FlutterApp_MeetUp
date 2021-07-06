import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // create user obj based on FirebaseUser

  UserId? _userIdFromJson(User? user) {
    // ignore: unnecessary_null_comparison
    return user != null ? UserId(uid: user.uid) : null;
  }

// auth change user stream
  Stream<UserId?> get user {
    return _auth.authStateChanges().map((User? user) => _userIdFromJson(user));
  }

  //sign in anon
  Future signInAnom() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userIdFromJson(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & pass
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userIdFromJson(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & pass
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid, chatId: '')
          .updateUserData('Like?', 'Name?', 45);
      return _userIdFromJson(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
