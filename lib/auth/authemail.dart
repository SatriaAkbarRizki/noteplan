import 'package:firebase_auth/firebase_auth.dart';

class AuthEmail {
  FirebaseAuth auth = FirebaseAuth.instance;
  get user => auth.currentUser;
  Future signUpEmail(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('Eror SignUp: ${e.toString()}');
    }
  }

  Future signInEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('Eror SignInEmail: ${e.toString()}');
    }
  }

  Future signOutEmail() async {
    await auth.signOut();
  }
}
