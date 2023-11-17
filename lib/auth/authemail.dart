import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthEmail {
  FirebaseAuth auth = FirebaseAuth.instance;
  get user => auth.currentUser;
  Future<String?> signUpEmail(String email, String password) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      const message = "Succes";
      return message;
    } on FirebaseAuthException catch (e) {
      final result = e.message.toString();
      // print('Eror SignUp: ${e.message.toString()}');
      return result;
    }
  }

  Future<String?> signInEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      String id = user.uid.toString();
      return id;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Eror SignInEmail: ${e.toString()}');
      }
    }
    return null;
  }

  Future signOutEmail() async {
    await auth.signOut();
  }

  Future resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}
